resource "aws_api_gateway_method" "access_handler_proxy_any" {
  rest_api_id   = aws_api_gateway_rest_api.access_handler.id
  resource_id   = aws_api_gateway_resource.access_handler_proxy.id
  http_method   = "ANY"
  authorization = "AWS_IAM"
}
