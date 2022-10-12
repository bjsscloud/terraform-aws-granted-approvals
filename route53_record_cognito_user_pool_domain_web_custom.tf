resource "aws_route53_record" "cognito_user_pool_domain_web_custom" {
  count = var.public_hosted_zone_id == null ? 0 : 1

  name    = "${local.web_cognito_user_pool_domain}."
  type    = "A"
  zone_id = var.public_hosted_zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.web_custom[0].cloudfront_distribution_arn

    # Static
    zone_id = "Z2FDTNDATAQYW2"
  }
}
