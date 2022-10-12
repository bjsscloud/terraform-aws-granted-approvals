resource "aws_route53_record" "frontend" {
  count = var.public_hosted_zone_id == null ? 0 : 1

  name    = "${local.frontend_domain}."
  type    = "A"
  zone_id = var.public_hosted_zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
  }
}
