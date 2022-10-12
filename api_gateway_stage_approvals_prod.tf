resource "aws_api_gateway_stage" "approvals_prod" {
  deployment_id = aws_api_gateway_deployment.approvals.id
  rest_api_id   = aws_api_gateway_rest_api.approvals.id
  stage_name    = "prod"

  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_approvals_prod_access.arn

    format = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
  }

  depends_on = [
    aws_api_gateway_account.main,
  ]
}
