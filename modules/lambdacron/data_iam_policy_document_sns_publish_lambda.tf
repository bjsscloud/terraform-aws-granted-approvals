data "aws_iam_policy_document" "sns_publish_lambda" {
  statement {
    sid    = "AllowLambdaToPublishToTopic"
    effect = "Allow"

    actions = [
      "SNS:Publish",
    ]

    resources = [
      aws_sns_topic.main[0].arn
    ]
  }

  statement {
    sid    = "AllowLambdaToKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]

    resources = [
      module.kms.key_arn,
    ]
  }

}
