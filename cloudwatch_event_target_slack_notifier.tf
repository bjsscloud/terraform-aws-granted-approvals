resource "aws_cloudwatch_event_target" "slack_notifier" {
  target_id      = "${local.csi}-slack-notifier"
  event_bus_name = aws_cloudwatch_event_bus.main.name
  rule           = aws_cloudwatch_event_rule.slack_notifier.name
  arn            = module.lambdacron_slack_notifier.lambda_function_arn

  retry_policy {
    maximum_event_age_in_seconds = 86400 # 60-86400
    maximum_retry_attempts       = 2 # 0-185
  }
}

