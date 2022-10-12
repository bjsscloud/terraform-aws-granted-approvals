resource "aws_cloudfront_origin_access_identity" "frontend" {
  comment = "${local.csi}-frontend"
}
