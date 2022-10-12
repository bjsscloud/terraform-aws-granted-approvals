resource "aws_acm_certificate" "frontend" {
  provider = aws.us-east-1
  count    = var.public_hosted_zone_id == null ? 0 : 1

  domain_name       = local.frontend_domain_custom_value
  validation_method = "DNS"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-frontend"
    }
  )
}

