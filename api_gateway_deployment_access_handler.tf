resource "aws_api_gateway_deployment" "access_handler" {
  description = "${local.csi}-access-handler"
  rest_api_id = aws_api_gateway_rest_api.access_handler.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.access_handler_proxy_any,
      aws_api_gateway_method.access_handler_proxy_any,
      aws_api_gateway_resource.access_handler_proxy,
      aws_api_gateway_rest_api.access_handler,
    ]))
  }

  depends_on = [
    aws_api_gateway_integration.access_handler_proxy_any,
    aws_api_gateway_method.access_handler_proxy_any,
    aws_api_gateway_resource.access_handler_proxy,
  ]
}
