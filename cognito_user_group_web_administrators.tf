resource "aws_cognito_user_group" "web_administrators" {
  count = var.identity_provider_type == "cognito" ? 1 : 0

  name         = "granted_administrators"
  user_pool_id = aws_cognito_user_pool.web.id
  description  = "Administrators role for Granted Approvals Web Dashboard, all cognito users assigned to this group will have access to admin features"
  precedence   = 0
}

