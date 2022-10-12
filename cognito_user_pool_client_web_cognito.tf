resource "aws_cognito_user_pool_client" "web_cognito" {
  count = var.identity_provider_type == "cognito" ? 1 : 0
  name  = "${local.csi}-web-cognito"

  user_pool_id = aws_cognito_user_pool.web.id

  access_token_validity = 480

  allowed_oauth_flows = [
    "code",
  ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = var.web_cognito_allowed_oauth_scopes

  callback_urls = [
    "https://${local.frontend_domain}",
  ]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
  ]

  logout_urls = [
    "https://${local.frontend_domain}",
  ]

  supported_identity_providers = [
    "COGNITO",
  ]

  token_validity_units {
    access_token = "minutes"
  }
}
