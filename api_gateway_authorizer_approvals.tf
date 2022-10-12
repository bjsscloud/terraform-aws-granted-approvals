resource "aws_api_gateway_authorizer" "approvals" {
  name = "${local.csi}-approvals"

  identity_source = "method.request.header.Authorization"

  provider_arns = [
    aws_cognito_user_pool.web.arn,
  ]

  rest_api_id = aws_api_gateway_rest_api.approvals.id
  type        = "COGNITO_USER_POOLS"
}
