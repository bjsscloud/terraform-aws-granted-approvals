resource "aws_acm_certificate" "cognito_user_pool_domain_web_custom" {
  provider = aws.us-east-1
  count    = var.public_hosted_zone_id == null ? 0 : 1

  domain_name       = local.web_cognito_user_pool_domain
  validation_method = "DNS"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-cognito-user-pool-domain-web-custom"
    }
  )
}

