resource "aws_api_gateway_rest_api" "access_handler" {
  name = "${local.csi}-access-handler"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-access-handler",
    }
  )
}
