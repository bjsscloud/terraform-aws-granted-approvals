data "aws_iam_policy_document" "cognito_user_pool_web_assumerole" {
  statement {
    sid    = "WebCognitoUserPoolAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "cognito-idp.${var.aws_url_suffix}",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "${local.csi}-cognito-user-pool-web",
      ]
    }
  }
}
