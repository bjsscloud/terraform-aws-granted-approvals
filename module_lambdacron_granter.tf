module "lambdacron_granter" {
  source = "./modules/lambdacron"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  function_name         = "granted-granter"
  description           = "${local.csi} Granter"
  memory                = 128
  runtime               = "go1.x"
  timeout               = 300
  log_retention_in_days = var.lambda_function_log_retention_in_days

  iam_policy_documents = [
    data.aws_iam_policy_document.aws_access_manage.json,
    data.aws_iam_policy_document.event_bus_put_events.json,
    data.aws_iam_policy_document.parameter_store_providers_read.json,
  ]

  function_source_type      = "s3"
  function_source_s3_bucket = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionBucket"]
  function_source_s3_key    = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionArchives"]["granter"]

  handler_function_name = "granter"

  lambda_env_vars = {
    COMMONFATE_EVENT_BUS_ARN    = aws_cloudwatch_event_bus.main.arn
    COMMONFATE_EVENT_BUS_SOURCE = var.event_bus_source_key
    COMMONFATE_PROVIDER_CONFIG  = local.commonfate_provider_configuration
  }

  subscription_arns = var.lambda_dlq_targets

  use_lambda_insights = true

  default_tags = local.default_tags
}

