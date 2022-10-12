data "aws_iam_policy_document" "apigateway_assumerole" {
  count = var.api_gateway_account_enabled ? 1 : 0

  statement {
    sid    = "ApiGatewayAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "apigateway.${var.aws_url_suffix}",
      ]
    }
  }
}
