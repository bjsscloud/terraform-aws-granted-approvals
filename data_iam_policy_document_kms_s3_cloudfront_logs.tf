data "aws_iam_policy_document" "kms_s3_cloudfront_logs" {
  statement {
    sid    = "AllowCloudfrontUse"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    ]

    principals {
      type = "Service"

      identifiers = [
        "delivery.logs.${var.aws_url_suffix}",
      ]
    }

    resources = [
      "*",
    ]
  }
}
