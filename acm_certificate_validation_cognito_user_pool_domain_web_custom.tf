resource "aws_acm_certificate_validation" "cognito_user_pool_domain_web_custom" {
  provider = aws.us-east-1
  count    = var.public_hosted_zone_id == null ? 0 : 1

  certificate_arn = aws_acm_certificate.cognito_user_pool_domain_web_custom[0].arn

  validation_record_fqdns = [
    for record in aws_route53_record.cognito_user_pool_domain_web_custom_validation: record.fqdn
  ]

  timeouts {
    create = "5m"
  }
}
