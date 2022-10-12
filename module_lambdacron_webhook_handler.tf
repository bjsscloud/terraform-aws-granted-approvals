module "lambdacron_webhook_handler" {
  source = "./modules/lambdacron"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  function_name         = "granted-webhook-handler"
  description           = "${local.csi} Webhook Handler"
  memory                = 128
  runtime               = "go1.x"
  timeout               = 20
  log_retention_in_days = var.lambda_function_log_retention_in_days

  allowed_triggers = {
    ApiGatewayApprovalsWebhook = {
      service        = "apigateway"

      source_arn = format(
        "arn:%s:execute-api:%s:%s:%s/%s/*/webhook/v1/*",
        var.aws_partition,
        var.region,
        var.aws_account_id,
        aws_api_gateway_rest_api.approvals.id,
        aws_api_gateway_stage.approvals_prod.stage_name,
      )
    }
  }

  iam_policy_documents = [
    data.aws_iam_policy_document.dynamodb_table_use.json,
  ]

  function_source_type      = "s3"
  function_source_s3_bucket = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionBucket"]
  function_source_s3_key    = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionArchives"]["webhook"]

  handler_function_name = "webhook"

  lambda_env_vars = {}

  subscription_arns = var.lambda_dlq_targets

  use_lambda_insights = true

  default_tags = local.default_tags
}

