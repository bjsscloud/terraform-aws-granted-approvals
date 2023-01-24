module "lambdacron_frontend_deployer" {
  source = "./modules/lambdacron"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  function_name         = "granted-frontend-deployer"
  description           = "${local.csi} Frontend Deployer"
  memory                = 128
  runtime               = "nodejs16.x"
  timeout               = 300
  log_retention_in_days = var.lambda_function_log_retention_in_days

  iam_policy_documents = [
    data.aws_iam_policy_document.lambdacron_frontend_deployer.json,
  ]

  function_source_type  = "directory"
  function_dir          = "${path.module}/files/frontend-deployer/dist"
  function_module_name  = "handler"
  handler_function_name = "handler"

  lambda_env_vars = {
    FUNCTION_LIST = jsonencode([
      "access-handler",
      "commonfate",
      "event-handler",
      "granter",
      "syncer",
      "slack-notifier",
      "cache-sync",
      "webhook",
    ])
  }

  subscription_arns = var.lambda_dlq_targets

  use_lambda_insights = true

  default_tags = local.default_tags
}

