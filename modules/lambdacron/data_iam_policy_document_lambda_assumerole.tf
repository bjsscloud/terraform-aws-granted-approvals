data "aws_iam_policy_document" "lambda_assumerole" {
  statement {
    sid    = "LambdaAssumeRole"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "lambda.${var.aws_url_suffix}",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

