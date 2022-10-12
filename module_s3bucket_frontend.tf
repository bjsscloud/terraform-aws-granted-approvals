module "s3bucket_frontend" {
  source = "./modules/s3bucket"

  aws_account_id = var.aws_account_id
  region         = var.region
  project        = var.project
  environment    = var.environment
  component      = var.component

  name = "${local.csi_global}-frontend"

  policy_documents = [ data.aws_iam_policy_document.s3_frontend.json ]

  # For now it's not worth encrypting these public assets
  # given the Lambda@Edge and KMS Overheads when acting as a CloudFront origin
  # kms_key_arn = module.kms_s3_frontend.key_arn

  # Enable S3 Bucket Logging to the logs bucket
  bucket_logging_target = var.s3_access_logs_s3_bucket_id == null ? {} : {
    bucket = var.s3_access_logs_s3_bucket_id
  }

  default_tags = local.default_tags
}
