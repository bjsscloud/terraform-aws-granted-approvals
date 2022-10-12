resource "aws_api_gateway_integration" "access_handler_proxy_any" {
  rest_api_id = aws_api_gateway_rest_api.access_handler.id
  resource_id = aws_api_gateway_resource.access_handler_proxy.id
  http_method = aws_api_gateway_method.access_handler_proxy_any.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = format(
    "arn:%s:apigateway:%s:lambda:path/2015-03-31/functions/%s/invocations",
    var.aws_partition,
    var.region,
    module.lambdacron_access_handler.lambda_function_arn,
  )
}
