resource "aws_sns_topic_policy" "main" {
  count = var.enable_dlq ? 1 : 0

  arn    = aws_sns_topic.main[0].arn
  policy = data.aws_iam_policy_document.sns_publish_services.json
}
