resource "aws_cognito_user_pool_domain" "web_prefix" {
  count = var.public_hosted_zone_id == null ? 1 : 0

  domain       = local.web_cognito_user_pool_domain_prefix
  user_pool_id = aws_cognito_user_pool.web.id
}
