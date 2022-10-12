resource "aws_cloudwatch_event_rule" "event_handler" {
  name           = "${local.csi}-event-handler"
  description    = "${local.csi}-event-handler"
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
      Name = "${local.csi}-event-handler",
    }
  )
}
