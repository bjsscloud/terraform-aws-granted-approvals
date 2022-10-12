resource "aws_lambda_function" "main" {
  description   = var.description
  function_name = var.absolute_function_name ? var.function_name : local.csi
  role          = aws_iam_role.main.arn
  handler       = var.function_module_name == null ? var.handler_function_name : "${var.function_module_name}.${var.handler_function_name}"
  runtime       = var.runtime
  publish       = true
  memory_size   = var.memory
  timeout       = var.timeout

  # If function_source_s3_bucket and function_source_s3_key are provided,
  # data source the object to confirm it's there, and depend on the output
  # for bucket, key and version ID information.
  #
  # This is only possible when the s3_bucket is in the same region as the function,
  # otherwise you will need to copy the archive locally using e.g. an AWS CLI call
  # and pass the base64 content from that file into var.function_source_archive_file_path
  s3_bucket         = var.function_source_type == "s3" ? data.aws_s3_object.function_source[0].bucket : null
  s3_key            = var.function_source_type == "s3" ? data.aws_s3_object.function_source[0].key : null
  s3_object_version = var.function_source_type == "s3" ? data.aws_s3_object.function_source[0].version_id : null

  # If (function_source && function_file_extension) or (function_dir) or (function_source_archive_file_path) are provided
  # then we are uploading a zip file from local.archive_path, otherwise it must be the s3 section above
  filename = (
    var.function_source_type == "s3" ?
      null :
      var.function_source_type == "file" || var.function_source_type == "directory" ?
        local.archive_path :
        var.function_source_type == "archive" ?
          var.function_source_archive_file_path :
          null
  )

  # If we havent an S3 bucket or zip content, we're zipping our own file, and need base64sha256 of it
  # If we havent an S3 bucket, but we do have a source archive path, then calculate base64sha256 of the file
  # If we have an S3 bucket, and not zip content, then the version_id of the S3 Object is used as the hash.
  source_code_hash = (
    var.function_source_type == "file" || var.function_source_type == "directory" ?
      data.archive_file.main[0].output_base64sha256 :
      var.function_source_type == "archive" ?
        filebase64sha256(var.function_source_archive_file_path) :
        null
  )

  dynamic "dead_letter_config" {
    for_each = var.enable_dlq != true ? toset([]) : toset([1])

    content {
      target_arn = aws_sns_topic.main[0].arn
    }
  }

  layers = local.lambda_layers

  tracing_config {
    mode = var.xray_mode
  }

  environment {
    variables = merge(
      {
        REGION = var.region
      },
      var.lambda_env_vars,
    )
  }

  tags = merge(
    local.default_tags,
    {
      Name = var.absolute_function_name ? var.function_name : local.csi
    },
  )

  # This depends_on is used to ensure
  # * The log group is in place before the lambda
  #   even exists, so that whenever we have a lambda execution,
  #   a logging destination is guaranteed.
  # * Any local file processing for the function archive is complete
  depends_on = [
    aws_cloudwatch_log_group.main,
    data.archive_file.main,
  ]

  # Le sigh
  provisioner "local-exec" {
    command = "sleep 15"
  }
}
