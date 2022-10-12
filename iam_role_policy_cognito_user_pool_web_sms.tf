resource "aws_iam_role_policy" "cognito_user_pool_web_sms" {
  name = "${local.csi}-cognito-user-pool-web-sms"
  role = aws_iam_role.cognito_user_pool_web_sms.id

  # TODO: Scope this down!
  policy = data.aws_iam_policy_document.sns_publish.json
}
