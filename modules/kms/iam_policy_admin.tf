# Create the Key Policy for the AWS KMS Key
resource "aws_iam_policy" "admin" {
  name   = "${local.csi_account}-admin"
  path   = "/"
  policy = data.aws_iam_policy_document.admin.json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi_account}-admin",
    },
  )
}
