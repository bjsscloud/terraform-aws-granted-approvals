module "lambdacron_approvals" {
  source = "./modules/lambdacron"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  function_name         = "commonfate"
  description           = "${local.csi} Approvals"
  memory                = 128
  runtime               = "go1.x"
  timeout               = 60
  log_retention_in_days = var.lambda_function_log_retention_in_days

  allowed_triggers = {
    ApiGatewayApprovalsApi = {
      service = "apigateway"

      source_arn = format(
        "arn:%s:execute-api:%s:%s:%s/%s/*/api/v1/*",
        var.aws_partition,
        var.region,
        var.aws_account_id,
        aws_api_gateway_rest_api.approvals.id,
        aws_api_gateway_stage.approvals_prod.stage_name,
      )
    }
  }

  iam_policy_documents = [
    data.aws_iam_policy_document.cognito_user_pool_web_read_create_entities.json,
    data.aws_iam_policy_document.dynamodb_table_use.json,
    data.aws_iam_policy_document.event_bus_put_events.json,
    data.aws_iam_policy_document.parameter_store_secrets_identity_read_write.json,
    data.aws_iam_policy_document.parameter_store_providers_write.json,
    data.aws_iam_policy_document.rest_api_access_handler_invoke.json,
  ]

  function_source_type      = "s3"
  function_source_s3_bucket = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionBucket"]
  function_source_s3_key    = jsondecode(aws_lambda_invocation.frontend_deployer.result)["functionArchives"]["commonfate"]

  handler_function_name = "commonfate"

  lambda_env_vars = {
    COMMONFATE_ACCESS_HANDLER_EXECUTION_ROLE_ARN = module.lambdacron_access_handler.iam_role_arn

    COMMONFATE_ACCESS_HANDLER_URL = format(
      "https://%s.execute-api.%s.%s/%s/",
      aws_api_gateway_rest_api.access_handler.id,
      var.region,
      var.aws_url_suffix,
      aws_api_gateway_stage.access_handler_prod.stage_name,
    )

    COMMONFATE_ADMIN_GROUP            = var.administrator_group_id
    COMMONFATE_COGNITO_USER_POOL_ID   = aws_cognito_user_pool.web.id
    COMMONFATE_FRONTEND_URL           = "https://${local.frontend_domain}"
    COMMONFATE_TABLE_NAME             = aws_dynamodb_table.main.name
    COMMONFATE_DEPLOYMENT_SUFFIX      = local.csi
    COMMONFATE_EVENT_BUS_ARN          = aws_cloudwatch_event_bus.main.arn
    COMMONFATE_EVENT_BUS_SOURCE       = var.event_bus_source_key
    COMMONFATE_IDENTITY_PROVIDER      = var.identity_provider_type
    COMMONFATE_IDENTITY_SETTINGS      = local.identity_configuration
    COMMONFATE_MOCK_ACCESS_HANDLER    = false
    COMMONFATE_NOTIFICATIONS_SETTINGS = local.notifications_configuration
    COMMONFATE_PAGINATION_KMS_KEY_ARN = module.kms_api_pagination.key_arn
    COMMONFATE_PROVIDER_CONFIG        = local.commonfate_provider_configuration
  }

  subscription_arns = var.lambda_dlq_targets

  use_lambda_insights = true

  default_tags = local.default_tags
}

