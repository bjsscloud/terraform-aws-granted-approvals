resource "aws_iam_policy" "sfn_access_handler" {
  name   = "${local.csi}-sfn-access-handler"
  path   = "/"
  policy = data.aws_iam_policy_document.sfn_access_handler.json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-sfn-access-handler"
    }
  )
}
