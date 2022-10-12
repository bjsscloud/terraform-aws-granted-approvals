resource "aws_cognito_user_pool_client" "web_saml" {
  count = var.identity_provider_type == "cognito" ? 0 : var.saml_sso_metadata_content == null && var.saml_sso_metadata_url == null ? 0 : 1
  name  = "${local.csi}-web-saml"

  user_pool_id = aws_cognito_user_pool.web.id

  access_token_validity = 480

  allowed_oauth_flows = [
    "implicit",
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
    local.web_cognito_identity_provider_name,
  ]

  token_validity_units {
    access_token = "minutes"
  }

  depends_on = [
    aws_cognito_identity_provider.web_saml,
  ]
}
