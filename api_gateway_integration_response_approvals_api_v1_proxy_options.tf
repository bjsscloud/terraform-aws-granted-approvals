resource "aws_api_gateway_integration_response" "approvals_api_v1_proxy_options_200" {
  rest_api_id = aws_api_gateway_rest_api.approvals.id
  resource_id = aws_api_gateway_resource.approvals_api_v1_proxy.id
  http_method = aws_api_gateway_method.approvals_api_v1_proxy_options.http_method
  status_code = aws_api_gateway_method_response.approvals_api_v1_proxy_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,X-Amz-Security-Token,Authorization,X-Api-Key,X-Requested-With,Accept,Access-Control-Allow-Methods,Access-Control-Allow-Origin,Access-Control-Allow-Headers'"
    "method.response.header.Access-Control-Allow-Origin"      = "'*'"
    "method.response.header.Access-Control-Allow-Credentials" = "'false'"
    "method.response.header.Access-Control-Allow-Methods"     = "'OPTIONS,GET,PUT,POST,DELETE'"
  }
}
