data "aws_iam_policy_document" "lambda_execution" {
  source_policy_documents = var.iam_policy_documents

  statement {
    sid    = "AllowLogging"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.main.arn}:*",
    ]
  }
}
