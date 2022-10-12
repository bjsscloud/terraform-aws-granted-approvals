resource "aws_cloudwatch_event_rule" "event_log" {
  name           = "${local.csi}-event-log"
  description    = "${local.csi}-event-log"
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
      Name = "${local.csi}-event-log",
    }
  )
}
