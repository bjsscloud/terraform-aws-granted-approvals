resource "aws_api_gateway_deployment" "approvals" {
  description = "${local.csi}-approvals"
  rest_api_id = aws_api_gateway_rest_api.approvals.id

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_authorizer.approvals,
      aws_api_gateway_integration.approvals_api_v1_proxy_any,
      aws_api_gateway_integration.approvals_api_v1_proxy_options,
      aws_api_gateway_integration.approvals_webhook_v1_proxy_any,
      aws_api_gateway_integration_response.approvals_api_v1_proxy_options_200,
      aws_api_gateway_method.approvals_api_v1_proxy_any,
      aws_api_gateway_method.approvals_api_v1_proxy_options,
      aws_api_gateway_method.approvals_webhook_v1_proxy_any,
      aws_api_gateway_method_response.approvals_api_v1_proxy_any_200,
      aws_api_gateway_method_response.approvals_api_v1_proxy_options_200,
      aws_api_gateway_resource.approvals_api,
      aws_api_gateway_resource.approvals_api_v1,
      aws_api_gateway_resource.approvals_api_v1_proxy,
      aws_api_gateway_resource.approvals_webhook,
      aws_api_gateway_resource.approvals_webhook_v1,
      aws_api_gateway_resource.approvals_webhook_v1_proxy,
      aws_api_gateway_rest_api.approvals,
    ]))
  }

  depends_on = [
    aws_api_gateway_integration.approvals_api_v1_proxy_any,
    aws_api_gateway_integration.approvals_api_v1_proxy_options,
    aws_api_gateway_integration.approvals_webhook_v1_proxy_any,
    aws_api_gateway_integration_response.approvals_api_v1_proxy_options_200,
    aws_api_gateway_method.approvals_api_v1_proxy_any,
    aws_api_gateway_method.approvals_api_v1_proxy_options,
    aws_api_gateway_method.approvals_webhook_v1_proxy_any,
    aws_api_gateway_method_response.approvals_api_v1_proxy_options_200,
    aws_api_gateway_resource.approvals_api,
    aws_api_gateway_resource.approvals_api_v1,
    aws_api_gateway_resource.approvals_api_v1_proxy,
    aws_api_gateway_resource.approvals_webhook,
    aws_api_gateway_resource.approvals_webhook_v1,
    aws_api_gateway_resource.approvals_webhook_v1_proxy,
  ]
}
