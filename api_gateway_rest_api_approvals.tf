resource "aws_api_gateway_rest_api" "approvals" {
  name = "${local.csi}-approvals"

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-approvals",
    }
  )
}
