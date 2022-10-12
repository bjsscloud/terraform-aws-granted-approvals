resource "aws_iam_role" "cognito_user_pool_web_sms" {
  name               = "${local.csi}-cognito-user-pool-web-sms"
  assume_role_policy = data.aws_iam_policy_document.cognito_user_pool_web_assumerole.json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-cognito-user-pool-web-sms"
    }
  )

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
