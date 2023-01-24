module "lambdacron_idp_sync" {
  source = "./modules/lambdacron"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  function_name         = "granted-idp-sync"
  description           = "${local.csi} IdP Synchronisation"
  memory                = 128
  runtime               = "go1.x"
  timeout               = 20
  log_retention_in_days = var.lambda_function_log_retention_in_days

  iam_policy_documents = [
    data.aws_iam_policy_document.cognito_user_pool_web_manage.json,
    data.aws_iam_policy_document.dynamodb_table_use.json,
    data.aws_iam_policy_document.parameter_store_secrets_identity_read.json,
  ]

  schedule = var.idp_sync_schedule

  function_source_type      = "s3"
  function_source_s3_bucket = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionBucket"]
  function_source_s3_key    = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionArchives"]["syncer"]

  handler_function_name = "syncer"

  lambda_env_vars = {
    COMMONFATE_COGNITO_USER_POOL_ID = aws_cognito_user_pool.web.id
    COMMONFATE_TABLE_NAME           = aws_dynamodb_table.main.name
    COMMONFATE_IDENTITY_PROVIDER    = var.identity_provider_type
    COMMONFATE_IDENTITY_SETTINGS    = local.identity_configuration
  }

  subscription_arns = var.lambda_dlq_targets

  use_lambda_insights = true

  default_tags = local.default_tags
}

