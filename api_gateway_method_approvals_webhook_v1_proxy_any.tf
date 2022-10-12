resource "aws_api_gateway_method" "approvals_webhook_v1_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.approvals.id
  resource_id   = aws_api_gateway_resource.approvals_webhook_v1_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}
