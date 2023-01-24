// vim: set syntax=javascript tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab :

const { getAwsResults } = require('orgtomate');

function getEnv(key) {
  let value = process.env[key];

  if ((value === undefined) || (value === null)) {
    throw new Error(`Environment Variable Missing: ${key} (${value})`);
  }

  return value;
}

/**
 * List of functions we expect to find in the CloudFormation
 *
 * e.g.
 *
 * [
 *   'access-handler',
 *   'commonfate',
 *   'event-handler',
 *   'granter',
 *   'syncer',
 *   'slack-notifier',
 *   'webhook',
 *   'cache-sync',
 * ]
 */
const functionList = JSON.parse(getEnv('FUNCTION_LIST'));

/* Lambda Execution Region */
const region = getEnv('REGION');

/* Debug if a DEBUG env var is present, regardless of value */
var debug = process.env.hasOwnProperty('DEBUG');

/**
 * Copy an object from one bucket to another
 * unless the object already exists in the target
 * based on a list of existing target keys
 */
const copyMissing = async (
  sourceBucket, /* Bucket to copy from */
  sourceKey,    /* Key to copy from */
  targetBucket, /* Bucket to copy to */
  targetKey,    /* Key to copy to */
  targetList,   /* List of keys that already exist */
) => {
  const source = `${sourceBucket}/${sourceKey}`;
  const target = `${targetBucket}/${targetKey}`;

  /* Return the key of the object IFF we copy it */
  let res = null;

  /* If we find the key in the list of existing targets we will skip it */
  let found = [];
  targetList.map((item) => {
    if (item.Key == targetKey) {
      found.push(item);
    }
  });

  if (found.length == 0) {
    /* We didn't find an existing item, we can copy it */
    debug && console.log(`Item ${target} not found in target.. copying`);

    await getAwsResults(
      'S3', 'copyObject',
      { region },
      {
        Bucket: targetBucket,
        CopySource: encodeURI(source),
        Key: targetKey,
      },
    ).catch((error) => {
      console.error(`Error in copyObject for s3://${source} to s3://${target}`);
      throw error;
    });

    /* Return the key to the object we copied */
    res = target;
  } else {
    debug && console.log(`Skipped: s3://${source} is already found as ${found[0].Key}`);
  }

  return res;
}

/**
 * Delete an object in a target bucket if it doesn't
 * exist in a source bucket. Optionally allow deletion
 * of an object that does exist in the source if it's
 * passed in the list of overrides
 */
const deleteMissing = async (
  sourceList,   /* List of object keys in the source bucket to care about */
  targetBucket, /* ID of the target bucket */
  targetKey,    /* Key of the object in both buckets */
  overrides     /* List of object keys that can be deleted even if they're in the source */
) => {

  /* Return the object key IFF we delete it */
  let res = null;

  /* See if the key is present in the source list */
  let found = [];
  sourceList.map((item) => {
    if (item.Key == targetKey) {
      found.push(item);
    }
  });

  /* Code deduplication */
  const target = `${targetBucket}/${targetKey}`;

  /**
   * If we didn't find the object in the source list,
   * or we're going to delete it due to override...
   */
  if (found.length == 0 || overrides.includes(targetKey)) {
    /* Log special exception cause */
    if ( overrides.includes(targetKey) ) { console.log(`Override Delete for ${targetKey}`); }

    /* Delete the object */
    await getAwsResults(
      'S3', 'deleteObject',
      { region },
      {
        Bucket: targetS3BucketId,
        Key: targetKey,
      },
    ).catch((error) => {
      console.error(`Error in deleteObject for s3://${target}`);
      console.error(JSON.stringify(error, null, 2));
      throw error;
    });

    /* Return that we deleted the object */
    res = target;
  } else {
    debug && console.log(`Skipped Delete of s3://${target} as it was found in the source to copy: ${found[0].Key}`);
  }

  return res;
}

/**
 * Create a CloudFront Invalidation
 */
const createInvalidation = async (
  distributionId,   /* Cloudfront Distribution ID */
  functionName,     /* Name of this lambda function (available in context object) */
  functionVersion,  /* Version of this lambda function (available in context object) */
  paths = ['/*'],   /* Paths to invalidate, which for us is always "everything" anyway */
) => {
  console.log(`Creating CloudFront Invalidation for distribution ${distributionId} ...`);

  const invalidationResult = await getAwsResults(
    'CloudFront', 'createInvalidation',
    { region },
    {
      DistributionId: distributionId,
      InvalidationBatch: {
        CallerReference: `${functionName}:${functionVersion}:${Math.floor(new Date().getTime() / 1000)}`,
        Paths: {
          Quantity: paths.length,
          Items: paths,
        }
      }
    },
  );

  let invalidation = invalidationResult.Invalidation;

  console.log(JSON.stringify(invalidation, null, 2));

  console.log('Checking for Invalidation success');
  const retries = 30;
  const sleep = 5;
  const invalidationId = invalidation.Id;
  for (let step = 1; step <= retries; step++) {
    const invalidations = await getAwsResults(
      'CloudFront', 'getInvalidation',
      { region },
      {
        DistributionId: distributionId,
        Id: invalidationId,
      }
    );

    invalidation = invalidations.Invalidation;
    const invalidationStatus = invalidation.Status;

    if (invalidationStatus !== 'InProgress') {
      if (invalidationStatus !== 'Completed') {
        console.log(`Invalidation ${invalidationId} no longer in progress, but status is not Completed (${invalidationStatus}). Please investigate!`);
      } else {
        console.log(`Invalidation ${invalidationId} completed.`);
      }

      return invalidation;
    }

    console.log(`(${step}/${retries}) Waiting for Invalidation ${invalidationId} to complete. Sleeping ${sleep}s...`);
    await new Promise(resolve => setTimeout(resolve, (sleep * 1000)));
  }

  console.error(`Timed out waiting for Invalidation ${invalidationId} to complete.`);
  return invalidation;
}

/**
 * Deploy Granted Function Archives and Frontend Assets
 * Finish with a CloudFront Invalidation. Ideally we would
 * only do this if changes are made, but there's so many
 * possible reasons to need an invalidation that we couldn't
 * know about, that it's safer to always invalidate. Especially
 * as this function is only called when an input to the function
 * changes in terraform.
 */
exports.handler = async (event, context, callback) => {
  // Log the event we received
  console.log('Received event: ', JSON.stringify(event, null, 2));

  /* Validate inputs */
  const getEventProperty = (key) => {
    if ( ( !event.hasOwnProperty(key) ) || event[key] === undefined || event[key] === null) {
      throw new Error('[FATAL] Event missing required property: ' + key);
    }

    return event[key];
  }

  const cloudfrontDistributionId = getEventProperty('cloudfrontDistributionId');
  const sourceS3BucketId         = getEventProperty('sourceS3BucketId');
  const targetS3BucketId         = getEventProperty('targetS3BucketId');
  const version                  = getEventProperty('version');

  if ( event.hasOwnProperty('debug') ) { debug = true };

  debug && console.log(`cloudfrontDistributionId: ${cloudfrontDistributionId}`);
  debug && console.log(`sourceS3BucketId: ${sourceS3BucketId}`);
  debug && console.log(`targetS3BucketId: ${targetS3BucketId}`);
  debug && console.log(`version: ${version}`);

  /**
   * When using a development version, the sources
   * are held under a top level prefix called "dev"
   * and then seperated by unique ID. If we have a dev
   * version, we need to know about the extra level of
   * depth in the source bucket
   */
  let dev_version;
  let path_depth = 1;
  if ( version.match(/^dev\/.+$/) ) {
    dev_version = version.split('/')[1];
    path_depth = 2;
    console.log(`Deploying Dev Version: ${dev_version} from s3://${sourceS3BucketId}`);
  } else {
    console.log(`Deploying Version: ${version} from s3://${sourceS3BucketId}`);
  }

  /* The output object returned to a synchronous invocation */
  let output = {};

  /**
   * We are going to return these properties no matter what
   * We are only returning them so that terraform has to
   * wait for the output from this function before proceeding
   * but the values are not variable
   */
  output['functionBucket'] = targetS3BucketId;

  output['functionArchives'] = {};
  functionList.map((name) => {
    output['functionArchives'][name] = `${version}/${name}.zip`;
  });

  output['copiedFiles'] = [];
  output['deletedFiles'] = [];
  output['cloudfrontInvalidation'] = {};

  /**
   * We need the Granted.template.json file to find out
   * which lambda function is which. They are named with
   * unique identifiers, and we are going to deploy them
   * to static filenames per function.
   */
  const grantedCloudFormationObjectKey = `${version}/Granted.template.json`;

  const cfn_json_object = await getAwsResults(
    'S3', 'getObject',
    { region },
    {
      Bucket: sourceS3BucketId,
      Key: grantedCloudFormationObjectKey,
    },
  ).catch((error) => {
    console.error(`Error in getObject for s3://${sourceS3BucketId}/${grantedCloudFormationObjectKey}`);
    console.error(JSON.stringify(error, null, 2));

    return undefined;
  });

  /**
   * Get a list of all objects in the target bucket
   * under the prefix for the version we are deploying
   * We need this whether the sources are available or not
   */
  const listTargetResponse = await getAwsResults(
    'S3', 'listObjects',
    { region },
    {
      Bucket: targetS3BucketId,
      Prefix: version,
    }
  );

  /* Extract the useful */
  const targetList = listTargetResponse.Contents;

  debug && console.log(`targetList: ${JSON.stringify(targetList, null, 2)}`);

  /**
   * If the getObject failed, then our upstream sources are unavailable.
   * If the sources we need are available in the target bucket, then
   * succeed anyway so that terraform can continue using them.
   * If they're not available, terraform cannot proceed anyway. Stop here.
   */
  if (cfn_json_object == undefined) {
    console.error('Upstream lambda function sources are unavailable. Checking if we have local sources...');
    for (const [key, value] of Object.entries(output['functionArchives'])) {
      if (!targetList.includes(value)) {
        throw new Error(`Upstream sources not available. Local copy of lambda function archive for ${key} does not exist at s3://${targetS3BucketId}/${value}`);
      }
    }

    console.log('Local lambda function sources verified');

    /**
     * The archives are present. Regardless of the frontend bucket assets status
     * which we cannot safely determine, terraform will be able to succeed with
     * the archives in place, so let's run the Cloudfront Invalidation and exit
     */
    output['cloudfrontInvalidation'] = await createInvalidation(
      cloudfrontDistributionId,
      context.functionName,
      context.functionVersion,
    );

    return output;
  }

  /* Our sources are (probably) available. Parse the CloudFormation into an object */
  const cfn = JSON.parse(cfn_json_object.Body.toString());

  /**
   * Extract from the object Resources that are Lambda Functions,
   * and populate the cfnLambdas object with a key of the
   * Lambda function's "Handler" property and a value
   * of the unique identifier used for that function.
   * Omit any functions with a dot (.) in their handler
   * name as these are not used in terraform.
   */
  let cfnLambdas = {};
  Object.keys(cfn.Resources).map(key => {
    const resource = cfn.Resources[key];
    if (resource.Type == 'AWS::Lambda::Function') {
      if (!resource.Properties.Handler.match(/^.+\..+/)) {
        cfnLambdas[resource.Properties.Handler] = resource.Properties.Code.S3Key.split('/')[path_depth].split('.')[0];
      }
    }
  });

  debug && console.log(`CFN Lambdas: ${JSON.stringify(cfnLambdas, null, 2)}`);

  /**
   * Get a list of all objects in the source bucket
   * under the prefix for the version we are deploying
   */
  const listSourceResponse = await getAwsResults(
    'S3', 'listObjects',
    { region },
    {
      Bucket: sourceS3BucketId,
      Prefix: version,
    }
  );

  /* Extract the useful */
  const sourceList = listSourceResponse.Contents;

  debug && console.log(`sourceList: ${JSON.stringify(sourceList, null, 2)}`);

  /* Array of parallelisable functions that perform S3 Copy Operations */
  let copyJobs = [];

  /* Array of parallelisable functions that perform S3 Delete Operations */
  let deleteJobs = [];

  /**
   * As we translate Lambda Function zip archives from a unique identifier
   * file name to a static file name per function, we need a list of
   * source and target file names so we can make sure not to delete
   * them after we have copied them when removing anything from the target
   * that isn't in the source.
   *
   * We also don't want to delete the aws-exports.json object
   * created by terraform after we run.
   */
  let keysToPreserve = [`${version}/aws-exports.json`];
  let keysToDeleteForcefully = [];

  for (const key in cfnLambdas) {
    const sourceFunctionKey = `${version}/${cfnLambdas[key]}.zip`;
    const targetFunctionKey = `${version}/${key}.zip`;

    /**
     * Add to the list of copy jobs a function to
     * copy a lambda function archive file unless
     * it already exists in the target (as we presume
     * the upstream storage is immutable).
     */
    copyJobs.push(
      await copyMissing(
        sourceS3BucketId,
        sourceFunctionKey,
        targetS3BucketId,
        targetFunctionKey,
        targetList,
      )
    );

    keysToPreserve.push(targetFunctionKey);
    keysToDeleteForcefully.push(sourceFunctionKey);
  }

  /**
   * For all objects in the target bucket under the prefix
   * for the version we are working on, delete any objects
   * that aren't in the source bucket, unless they are
   * specifically the lambda function archives we copied
   * from unique identifiers to static names
   */
  targetList.map((asset) => {
    if (! keysToPreserve.includes(asset.Key) ) {
      debug && console.log(`Going to delete ${asset.Key} unless it is in the source`);
      deleteJobs.push(
        deleteMissing(sourceList, targetS3BucketId, asset.Key, keysToDeleteForcefully)
      );
    } else {
      debug && console.log(`Skipping delete test on function archive ${asset.Key}`);
    }
  });

  /**
   * Now we're ready to copy the static website assets
   */
  const assetsPrefix = `${version}/frontend-assets`;
  const assetsRegex = new RegExp(`^${assetsPrefix}.+`);
  sourceList.map((asset) => {
    if (asset.Key.match(assetsRegex)) {
      copyJobs.push(
        copyMissing(
          sourceS3BucketId,
          asset.Key,
          targetS3BucketId,
          asset.Key,
          targetList,
        ).catch((err) => { throw err })
      )
    } else {
      debug && console.log(`Skipping copy test on asset which doesnt start with ${assetsPrefix} :: ${asset.Key}`);
    }
  });

  /**
   * Having set up all the delete and copy jobs to operate in parallel
   * it's now time to sit and wait for them all to complete
   */
  deleteJobsOutput = await Promise.allSettled(deleteJobs).catch((error) => { console.error(error.message); throw error; });
  copyJobsOutput = await Promise.allSettled(copyJobs).catch((error) => { console.error(error.message); throw error; });

  debug && console.log(`deleteJobsOutput: ${JSON.stringify(deleteJobsOutput, null, 2)}`);
  debug && console.log(`copyJobsOutput: ${JSON.stringify(copyJobsOutput, null, 2)}`);

  /**
   * As a result we want a list of objects we copied and objects we deleted
   */
  let deletedFiles = [];
  let copiedFiles = [];

  deleteJobsOutput.map((job) => {
    if (job.value !== null && job.value !== undefined) {
      debug && console.log(`Delete Job Value: ${job.value}`);
      deletedFiles.push(job.value);
    }
  });

  copyJobsOutput.map((job) => {
    if (job.value !== null && job.value !== undefined) {
      debug && console.log(`Copy Job Value: ${job.value}`);
      copiedFiles.push(job.value);
    }
  });

  if ( deletedFiles.length > 0 ) { console.log(`Deleted: ${JSON.stringify(deletedFiles, null, 2)}`); }
  if ( copiedFiles.length > 0 ) { console.log(`Copied: ${JSON.stringify(copiedFiles, null, 2)}`); }

  output['deletedFiles'] = deletedFiles;
  output['copiedFiles'] = copiedFiles;

  /**
   * We should never both copy and delete the same object
   * and our code logic shouldn't allow this. Just in case
   * something unexpected happens, keep an eye out for it
   */
  deletedFiles.map((deletedFile) => {
    if (copiedFiles.includes(deletedFile)) {
      throw new Error(`Major Logic Fail. Deleted file "${deletedFile}" was also copied! Investigate this!`);
    }
  });

  if ( (deletedFiles.length + copiedFiles.length) > 0 ) {
    console.log('Changes made.');
  } else {
    console.log('No changes. Deployment is up to date.');
  }

  output['cloudfrontInvalidation'] = await createInvalidation(
    cloudfrontDistributionId,
    context.functionName,
    context.functionVersion,
  );

  return output;
}

/**
 * If executing from the CLI, call the example function
 */
/*
if (require.main === module) {

  const _die = (error) => {
    console.error(error.message);
    process.exit(1);
  };

  try {
    const event = {
      cloudfrontDistributionId: getEnv('CLOUDFRONT_DISTRIBUTION_ID'),
      sourceS3BucketId: getEnv('SOURCE_S3_BUCKET_ID'),
      targetS3BucketId: getEnv('TARGET_S3_BUCKET_ID'),
      version: getEnv('VERSION'),
    };

    const context = {
      functionName: 'index.js',
      functionVersion: 0,
    }

    exports.handler(event, context).catch((err) => { _die(err); });
  } catch (err) {
    _die(err);
  }
}
*/
