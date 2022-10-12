resource "aws_cloudwatch_log_group" "api_gateway_approvals_prod_execution" {
  name              ="API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.approvals.id}/prod"
  retention_in_days = 30

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-api-gateway-approvals-prod-execution"
    }
  )
}
