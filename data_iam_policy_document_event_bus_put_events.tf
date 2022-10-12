data "aws_iam_policy_document" "event_bus_put_events" {
  statement {
    sid    = "AllowPutEvents"
    effect = "Allow"

    actions = [
      "events:PutEvents",
    ]

    resources = [
      aws_cloudwatch_event_bus.main.arn,
    ]
  }
}

