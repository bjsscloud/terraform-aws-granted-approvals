resource "aws_cloudwatch_event_target" "event_log" {
  target_id      = "${local.csi}-event-log"
  event_bus_name = aws_cloudwatch_event_bus.main.name
  rule           = aws_cloudwatch_event_rule.event_log.name
  arn            = aws_cloudwatch_log_group.events.arn

  retry_policy {
    maximum_event_age_in_seconds = 86400 # 60-86400
    maximum_retry_attempts       = 2 # 0-185
  }
}

