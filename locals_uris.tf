locals {
  approvals_api_url = format(
    "https://%s.execute-api.%s.%s/%s/",
    aws_api_gateway_rest_api.approvals.id,
    var.region,
    var.aws_url_suffix,
    aws_api_gateway_stage.approvals_prod.stage_name,
  )

  access_handler_api_url = format(
    "https://%s.execute-api.%s.%s/%s/",
    aws_api_gateway_rest_api.access_handler.id,
    var.region,
    var.aws_url_suffix,
    aws_api_gateway_stage.access_handler_prod.stage_name,
  )

  frontend_domain_custom_value = var.public_hosted_zone_id == null ? null : "granted.${data.aws_route53_zone.main[0].name}"
  frontend_domain = var.public_hosted_zone_id == null ? aws_cloudfront_distribution.frontend.domain_name : local.frontend_domain_custom_value
}
