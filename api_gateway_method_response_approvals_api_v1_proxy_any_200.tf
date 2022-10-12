resource "aws_api_gateway_method_response" "approvals_api_v1_proxy_any_200" {
  rest_api_id = aws_api_gateway_rest_api.approvals.id
  resource_id = aws_api_gateway_resource.approvals_api_v1_proxy.id
  http_method = aws_api_gateway_method.approvals_api_v1_proxy_any.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Credentials" = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
  }
}
