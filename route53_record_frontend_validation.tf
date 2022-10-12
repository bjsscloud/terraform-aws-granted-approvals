resource "aws_route53_record" "frontend_validation" {
  for_each = {
    for dvo in flatten ([
      for cert in aws_acm_certificate.frontend: cert.domain_validation_options
    ]): dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  zone_id = var.public_hosted_zone_id
  type    = each.value.type
  ttl     = "30"

  records = [
    each.value.record,
  ]
}
