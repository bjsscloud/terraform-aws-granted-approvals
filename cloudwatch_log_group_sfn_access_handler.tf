resource "aws_cloudwatch_log_group" "sfn_access_handler" {
  name  = "/aws/vendedlogs/states/${local.csi}-access-handler"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-sfn-access-handler"
    },
  )
}
