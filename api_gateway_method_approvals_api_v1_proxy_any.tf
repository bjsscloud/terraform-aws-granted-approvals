resource "aws_api_gateway_method" "approvals_api_v1_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.approvals.id
  resource_id   = aws_api_gateway_resource.approvals_api_v1_proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.approvals.id
}
