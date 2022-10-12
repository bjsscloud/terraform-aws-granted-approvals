resource "aws_cloudfront_distribution" "frontend" {
  enabled = "true"
  comment = "${local.csi}-frontend"

  # US and EU
  price_class         = "PriceClass_100"
  is_ipv6_enabled     = "false"
  default_root_object = "/index.html"

  origin {
    origin_id   = "${local.csi}-frontend"
    origin_path = "/${local.frontend_assets_key_prefix}"
    domain_name = module.s3bucket_frontend.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend.cloudfront_access_identity_path
    }
  }

  aliases = var.public_hosted_zone_id == null ? [] : [ local.frontend_domain_custom_value ]

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cache_policy_id = "b2884449-e4de-46a7-ac36-70bc7f1ddd6d" # TODO: data Source for CachingOptimizedForUncompressedObjects

    cached_methods = [
      "GET",
      "HEAD",
    ]

    compress = false

    target_origin_id = "${local.csi}-frontend"

    viewer_protocol_policy = "redirect-to-https"

    #min_ttl                = "0"
    #default_ttl            = "3600"
    #max_ttl                = "3600"
  }

  http_version = "http1.1"

  logging_config {
    bucket = module.s3bucket_cloudfront_logs.bucket_regional_domain_name
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "viewer_certificate" {
    for_each = var.public_hosted_zone_id == null ? [] : [1]

    content {
      acm_certificate_arn      = aws_acm_certificate.frontend[0].arn
      minimum_protocol_version = "TLSv1.2_2021"
      ssl_support_method       = "sni-only"
    }
  }

  dynamic "viewer_certificate" {
    for_each = var.public_hosted_zone_id == null ? [1] : []

    content {
      cloudfront_default_certificate = true
    }
  }

  #web_acl_id = aws_waf_web_acl.whitelist.id

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-frontend",
    }
  )

  depends_on = [
    aws_acm_certificate_validation.frontend,
    module.s3bucket_cloudfront_logs,
  ]
}
