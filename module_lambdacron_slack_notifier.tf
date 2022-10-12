module "lambdacron_slack_notifier" {
  source = "./modules/lambdacron"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  function_name         = "granted-slack-notifier"
  description           = "${local.csi} IdP Synchronisation"
  memory                = 128
  runtime               = "go1.x"
  timeout               = 20
  log_retention_in_days = var.lambda_function_log_retention_in_days

  allowed_triggers = {
   SlackNotifierEventRule = {
      service        = "events"
      source_account = var.aws_account_id
      source_arn     = aws_cloudwatch_event_rule.slack_notifier.arn
    }
  }

  iam_policy_documents = [
    data.aws_iam_policy_document.cognito_user_pool_web_admin_get_user.json,
    data.aws_iam_policy_document.dynamodb_table_use.json,
    data.aws_iam_policy_document.parameter_store_secrets_notifications_read.json,
  ]

  function_source_type      = "s3"
  function_source_s3_bucket = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionBucket"]
  function_source_s3_key    = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionArchives"]["slack-notifier"]

  handler_function_name = "slack-notifier"

  lambda_env_vars = {
    APPROVALS_COGNITO_USER_POOL_ID = aws_cognito_user_pool.web.id
    APPROVALS_FRONTEND_URL         = "https://${local.frontend_domain}"
    APPROVALS_TABLE_NAME           = aws_dynamodb_table.main.name
    NOTIFICATIONS_SETTINGS         = local.notifications_configuration
  }

  subscription_arns = var.lambda_dlq_targets

  use_lambda_insights = true

  default_tags = local.default_tags
}

