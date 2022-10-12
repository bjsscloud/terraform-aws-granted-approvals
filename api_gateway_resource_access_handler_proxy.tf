resource "aws_api_gateway_resource" "access_handler_proxy" {
  rest_api_id = aws_api_gateway_rest_api.access_handler.id
  parent_id   = aws_api_gateway_rest_api.access_handler.root_resource_id
  path_part   = "{proxy+}"
}
