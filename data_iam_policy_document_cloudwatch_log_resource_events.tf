data "aws_iam_policy_document" "cloudwatch_log_resource_events" {
  statement {
    sid    = "AllowEventsPutEvents"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.events.arn}:*",
    ]

    principals {
      type = "Service"

      identifiers = [
        "events.${var.aws_url_suffix}",
      ]
    }
  }
}
