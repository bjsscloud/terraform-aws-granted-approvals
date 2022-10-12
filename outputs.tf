##
# API Gateway
##

# Access Handler

output "access_handler_rest_api_endpoint" {
  description = "Access Handler REST API Endpoint URL"
  value       = local.access_handler_api_url
}

# Approvals

output "approvals_rest_api_endpoint" {
  description = "Approvals REST API Endpoint URL"
  value       = local.approvals_api_url
}

##
# API Pagination
##

output "api_pagination_kms_key_arn" {
  description = "API Pagination KMS Key ARN"
  value       = module.kms_api_pagination.key_arn
}

##
# AWS Region
##

output "region" {
  description = "AWS Region"
  value       = var.region
}

##
# Cognito
##

output "web_cognito_client_id" {
  description = "Web Cognito Client User Pool Client ID"
  value       = local.web_cognito_user_pool_client_id
}

output "web_cognito_user_pool_id" {
  description = "Web Cognito User Pool ID"
  value       = aws_cognito_user_pool.web.id
}

output "web_cognito_user_pool_domain" {
  description = "Web Cognito User Pool Domain"
  value       = local.web_cognito_user_pool_domain
}

##
# DynamoDB
##

output "dynamodb_table_id" {
  description = "DynamoDB Table ID"
  value       = aws_dynamodb_table.main.id
}

##
# EventBridge
##

output "event_bus_arn" {
  description = "EventBridge Event Bus ARN"
  value       = aws_cloudwatch_event_bus.main.arn
}

output "event_bus_source_key" {
  description = "EventBridge Event Bus Source Key"
  value       = var.event_bus_source_key
}

output "events_log_group_name" {
  description = "Events Cloudwatch Log Group Name"
  value       = aws_cloudwatch_log_group.events.name
}

##
# Frontend
##

output "frontend_cloudfront_distribution_id" {
  description = "Frontend CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.frontend.id
}

output "frontend_cloudfront_domain" {
  description = "Frontend CloudFront Domain Name"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "frontend_deployer_invocation_output" {
  description = "Frontend Deployer Lambda Function Invocation Result"
  value       = jsondecode(aws_lambda_invocation.frontend_deployer.result)
}

output "frontend_domain" {
  description = "Frontend Domain Name"
  value       = local.frontend_domain
}

output "frontend_s3_bucket_id" {
  description = "Frontend S3 Bucket ID"
  value       = module.s3bucket_frontend.id
}

##
# Lambda
##

# Access Handler

output "access_handler_lambda_execution_role_arn" {
  description = "Access Handler Lambda Execution Role ARN"
  value       = module.lambdacron_access_handler.iam_role_arn
}

output "access_handler_lambda_log_group_name" {
  description = "Access Handler Lambda Function Cloudwatch Log Group Name"
  value       = module.lambdacron_access_handler.log_group_name
}

# Approvals

output "approvals_lambda_log_group_name" {
  description = "Approval Lambda Function Cloudwatch Log Group Name"
  value       = module.lambdacron_approvals.log_group_name
}

# Event Handler

output "event_handler_lambda_log_group_name" {
  description = "Event Handler Lambda Function Log Group Name"
  value       = module.lambdacron_event_handler.log_group_name
}

# Granter

output "granter_lambda_log_group_name" {
  description = "Granter Lambda Function Cloudwatch Log Group Name"
  value       = module.lambdacron_granter.log_group_name
}

# IDP Sync

output "idp_sync_lambda_function_name" {
  description = "IDP Syncer Lambda Function Name"
  value       = module.lambdacron_idp_sync.lambda_function_name
}

output "idp_sync_lambda_log_group_name" {
  description = "IDP Syncer Lambda Function Cloudwatch Log Group Name"
  value       = module.lambdacron_idp_sync.log_group_name
}

# Slack Notifier

output "slack_notifier_lambda_log_group_name" {
  description = "Slack Notifier Lambda Cloudwatch Log Group Name"
  value       = module.lambdacron_slack_notifier.log_group_name
}

##
# Slack
##

output "slack_app_config" {
  description = "Slack Application Configuration Data"
  value       = local.slack_app_config
}

output "slack_app_create_url" {
  description = "Slack Application Auto-Creation URL"
  value       = "https://api.slack.com/apps?new_app=1&manifest_json=${urlencode(jsonencode(local.slack_app_config))}"
}

##
# StepFunctions
##

# Access Handler

output "access_handler_sfn_state_machine_arn" {
  description = "Access Handler Step Functions State Machine ARN"
  value       = aws_sfn_state_machine.access_handler.arn
}
