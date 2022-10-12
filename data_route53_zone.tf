data "aws_route53_zone" "main" {
  count = var.public_hosted_zone_id == null ? 0 : 1

  private_zone = false
  zone_id      = var.public_hosted_zone_id
}
