resource "aws_api_gateway_resource" "approvals_webhook_v1_proxy" {
  rest_api_id = aws_api_gateway_rest_api.approvals.id
  parent_id   = aws_api_gateway_resource.approvals_webhook_v1.id
  path_part   = "{proxy+}"
}
