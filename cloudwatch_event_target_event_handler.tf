resource "aws_cloudwatch_event_target" "event_handler" {
  target_id      = "${local.csi}-event-handler"
  event_bus_name = aws_cloudwatch_event_bus.main.name
  rule           = aws_cloudwatch_event_rule.event_handler.name
  arn            = module.lambdacron_event_handler.lambda_function_arn

  retry_policy {
    maximum_event_age_in_seconds = 86400 # 60-86400
    maximum_retry_attempts       = 2 # 0-185
  }
}

