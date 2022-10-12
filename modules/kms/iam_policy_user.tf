# Create the Key Policy for the AWS KMS Key
resource "aws_iam_policy" "user" {
  name   = "${local.csi_account}-user"
  path   = "/"
  policy = data.aws_iam_policy_document.user.json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi_account}-user",
    },
  )
}
