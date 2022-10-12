resource "aws_api_gateway_integration" "approvals_api_v1_proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.approvals.id
  resource_id = aws_api_gateway_resource.approvals_api_v1_proxy.id
  http_method = aws_api_gateway_method.approvals_api_v1_proxy_options.http_method

  passthrough_behavior = "NEVER"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }

  type = "MOCK"
}
