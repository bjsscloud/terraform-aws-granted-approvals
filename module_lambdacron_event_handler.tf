module "lambdacron_event_handler" {
  source = "./modules/lambdacron"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  function_name         = "granted-event-handler"
  description           = "${local.csi} Event Handler"
  memory                = 128
  runtime               = "go1.x"
  timeout               = 20
  log_retention_in_days = var.lambda_function_log_retention_in_days

  allowed_triggers = {
    EventHandlerEventRule = {
      service        = "events"
      source_account = var.aws_account_id
      source_arn     = aws_cloudwatch_event_rule.event_handler.arn
    }
  }

  iam_policy_documents = [
    data.aws_iam_policy_document.dynamodb_table_use.json,
  ]

  function_source_type      = "s3"
  function_source_s3_bucket = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionBucket"]
  function_source_s3_key    = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionArchives"]["event-handler"]

  handler_function_name = "event-handler"

  lambda_env_vars = {
    COMMONFATE_TABLE_NAME = aws_dynamodb_table.main.name
  }

  subscription_arns = var.lambda_dlq_targets

  use_lambda_insights = true

  default_tags = local.default_tags
}

