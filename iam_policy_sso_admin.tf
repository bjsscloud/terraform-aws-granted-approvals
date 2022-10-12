resource "aws_iam_policy" "sso_admin" {
  name   = "${local.csi}-sso-admin"
  path   = "/"
  policy = data.aws_iam_policy_document.sso_admin.json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-sso-admin"
    }
  )
}
