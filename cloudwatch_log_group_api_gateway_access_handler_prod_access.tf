resource "aws_cloudwatch_log_group" "api_gateway_access_handler_prod_access" {
  name              = "/aws/apigateway/${local.csi}/access-handler/prod"
  retention_in_days = 30

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-api-gateway-access-handler-prod-access"
    }
  )
}
