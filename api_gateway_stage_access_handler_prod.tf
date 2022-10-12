resource "aws_api_gateway_stage" "access_handler_prod" {
  deployment_id = aws_api_gateway_deployment.access_handler.id
  rest_api_id   = aws_api_gateway_rest_api.access_handler.id
  stage_name    = "prod"

  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_access_handler_prod_access.arn

    format = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
  }

  depends_on = [
    aws_api_gateway_account.main,
  ]
}
