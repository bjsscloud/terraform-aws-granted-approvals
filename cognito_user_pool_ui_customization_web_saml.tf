resource "aws_cognito_user_pool_ui_customization" "web_saml" {
  count = var.identity_provider_type == "cognito" ? 0 : 1

  client_id = aws_cognito_user_pool_client.web_saml[0].id

  css = var.web_cognito_custom_css

  image_file = (
    var.web_cognito_custom_image_file != null && var.web_cognito_custom_image_base64 == null ?
      filebase64(var.web_cognito_custom_image_file) : 
      var.web_cognito_custom_image_file == null && var.web_cognito_custom_image_base64 != null ?
        var.web_cognito_custom_image_base64 :
        null
  )

  # Refer to the aws_cognito_user_pool_domain resource's
  # user_pool_id attribute to ensure it is in an 'Active' state
  user_pool_id = (
    var.public_hosted_zone_id == null ?
      aws_cognito_user_pool_domain.web_prefix[0].user_pool_id :
      aws_cognito_user_pool_domain.web_custom[0].user_pool_id
  )

  depends_on = [
    aws_cognito_user_pool.web,
    aws_cognito_user_pool_domain.web_prefix,
    aws_cognito_user_pool_domain.web_custom,
  ]
}
