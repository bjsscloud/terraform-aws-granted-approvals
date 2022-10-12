resource "aws_api_gateway_resource" "approvals_api" {
  rest_api_id = aws_api_gateway_rest_api.approvals.id
  parent_id   = aws_api_gateway_rest_api.approvals.root_resource_id
  path_part   = "api"
}
