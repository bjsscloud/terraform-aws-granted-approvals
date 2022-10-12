resource "aws_cloudwatch_event_rule" "slack_notifier" {
  name           = "${local.csi}-slack-notifier"
  description    = "${local.csi}-slack-notifier"
  event_bus_name = aws_cloudwatch_event_bus.main.name
  is_enabled     = true

  event_pattern = jsonencode({
    source = [
      var.event_bus_source_key,
    ]
  })

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-slack-notifier",
    }
  )
}
