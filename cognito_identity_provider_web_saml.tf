resource "aws_cognito_identity_provider" "web_saml" {
  count = var.identity_provider_type == "cognito" ? 0 : var.saml_sso_metadata_content == null && var.saml_sso_metadata_url == null ? 0 : 1

  user_pool_id = aws_cognito_user_pool.web.id

  provider_name = local.web_cognito_identity_provider_name
  provider_type = "SAML"

  attribute_mapping = {
    email = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
  }

  provider_details = {
    MetadataFile = var.saml_sso_metadata_content
    MetadataURL  = var.saml_sso_metadata_url
  }

  # SLORedirectBindingURI and SSORedirectBindingURI are only populated from MetadataURL
  lifecycle {
    ignore_changes = [
      provider_details["SLORedirectBindingURI"],
      provider_details["SSORedirectBindingURI"]
    ]
  }
}

