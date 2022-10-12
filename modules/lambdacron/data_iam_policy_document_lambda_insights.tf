data "aws_iam_policy_document" "lambda_insights" {
  statement {
    sid    = "AllowCreateGroupAndStreamAndPutToStream"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/lambda-insights:*",
        var.aws_partition,
        var.region,
        var.aws_account_id,
      )
    ]
  }
}
