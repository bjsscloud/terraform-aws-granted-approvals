resource "aws_api_gateway_resource" "approvals_api_v1" {
  rest_api_id = aws_api_gateway_rest_api.approvals.id
  parent_id   = aws_api_gateway_resource.approvals_api.id
  path_part   = "v1"
}
