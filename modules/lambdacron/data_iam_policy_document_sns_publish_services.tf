data "aws_iam_policy_document" "sns_publish_services" {
  statement {
    sid    = "AllowEventsAndLambdaToPublishToTopic"
    effect = "Allow"

    actions = [
      "SNS:Publish",
    ]

    principals {
      type = "Service"

      identifiers = [
        "events.${var.aws_url_suffix}",
        "lambda.${var.aws_url_suffix}",
      ]
    }

    resources = [
      "*"
    ]
  }
}
