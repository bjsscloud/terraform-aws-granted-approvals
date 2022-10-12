locals {
  web_cognito_user_pool_client_id = (
    var.identity_provider_type == "cognito" ?
      aws_cognito_user_pool_client.web_cognito[0].id :
      aws_cognito_user_pool_client.web_saml[0].id
  )

  web_cognito_user_pool_domain_prefix = (
    var.public_hosted_zone_id == null ?
      "${local.csi}-web" :
      "auth"
  )

  web_cognito_user_pool_domain = (
    var.public_hosted_zone_id == null ?
      "${local.web_cognito_user_pool_domain_prefix}.auth.${var.region}.amazoncognito.com" :
      "${local.web_cognito_user_pool_domain_prefix}.${local.frontend_domain_custom_value}"
  )

  web_cognito_identity_provider_name = var.identity_provider_name == null ? var.identity_provider_type : var.identity_provider_name
}
