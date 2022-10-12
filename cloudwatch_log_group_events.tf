resource "aws_cloudwatch_log_group" "events" {
  name  = "${local.csi}-events"

  retention_in_days = 731

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-events"
    },
  )
}
