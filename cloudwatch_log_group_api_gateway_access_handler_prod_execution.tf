resource "aws_cloudwatch_log_group" "api_gateway_access_handler_prod_execution" {
  name              ="API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.access_handler.id}/prod"
  retention_in_days = 30

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-api-gateway-access-handler-prod-execution"
    }
  )
}
