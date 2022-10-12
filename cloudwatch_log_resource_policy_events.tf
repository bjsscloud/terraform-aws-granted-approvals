resource "aws_cloudwatch_log_resource_policy" "events" {
  policy_document = data.aws_iam_policy_document.cloudwatch_log_resource_events.json
  policy_name     = "${local.csi}-events"
}
