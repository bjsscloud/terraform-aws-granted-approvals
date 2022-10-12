resource "aws_iam_role_policy_attachment" "sso_admin_sso_admin" {
  role       = aws_iam_role.sso_admin.name
  policy_arn = aws_iam_policy.sso_admin.arn
}
