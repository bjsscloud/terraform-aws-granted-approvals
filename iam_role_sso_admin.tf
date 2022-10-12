resource "aws_iam_role" "sso_admin" {
  name               = "${local.csi}-sso-admin"
  assume_role_policy = data.aws_iam_policy_document.assumerole_sso_admin.json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-sso-admin"
    }
  )

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
