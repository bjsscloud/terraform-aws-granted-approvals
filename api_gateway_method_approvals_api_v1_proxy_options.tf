resource "aws_api_gateway_method" "approvals_api_v1_proxy_options" {
  rest_api_id   = aws_api_gateway_rest_api.approvals.id
  resource_id   = aws_api_gateway_resource.approvals_api_v1_proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
