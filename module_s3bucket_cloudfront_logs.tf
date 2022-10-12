module "s3bucket_cloudfront_logs" {
  source = "./modules/s3bucket"

  aws_account_id = var.aws_account_id
  region         = var.region
  project        = var.project
  environment    = var.environment
  component      = var.component

  name = "${local.csi_global}-cloudfront-logs"

  # Cloudfront steals your credentials to modify the Bucket ACL
  # to allow itself to write logs, so we don't need to explicitly
  # allow delivery.logs.amazonaws.com to write
  # policy_documents = [ data.aws_iam_policy_document.s3_cloudfront_logs.json ]

  # But we have granted use of this key to the delivery.logs principal
  kms_key_arn = module.kms_s3_cloudfront_logs.key_arn

  # Enable S3 Bucket Logging to the logs bucket
  bucket_logging_target = var.s3_access_logs_s3_bucket_id == null ? {} : {
    bucket = var.s3_access_logs_s3_bucket_id
  }

  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  #
  # Important
  # Don’t choose an Amazon S3 bucket with S3 Object Ownership set to bucket owner enforced.
  # That setting disables ACLs for the bucket and the objects in it, which prevents
  # CloudFront from delivering log files to the bucket.
  object_ownership = "BucketOwnerPreferred"

  default_tags = local.default_tags
}
