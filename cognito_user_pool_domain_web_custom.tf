resource "aws_cognito_user_pool_domain" "web_custom" {
  count = var.public_hosted_zone_id == null ? 0 : 1

  certificate_arn = aws_acm_certificate.cognito_user_pool_domain_web_custom[0].arn
  domain          = local.web_cognito_user_pool_domain
  user_pool_id    = aws_cognito_user_pool.web.id

  depends_on = [
    aws_acm_certificate_validation.cognito_user_pool_domain_web_custom,
  ]
}
