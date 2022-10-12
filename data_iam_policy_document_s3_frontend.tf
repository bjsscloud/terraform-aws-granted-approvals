data "aws_iam_policy_document" "s3_frontend" {
  statement {
    sid    = "AllowCloudfrontOaiGetObject"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.s3bucket_frontend.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.frontend.iam_arn,
      ]
    }
  }
}
