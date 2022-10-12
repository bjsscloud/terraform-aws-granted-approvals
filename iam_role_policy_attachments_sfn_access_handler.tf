resource "aws_iam_role_policy_attachment" "sfn_access_handler_sfn_access_handler" {
  role       = aws_iam_role.sfn_access_handler.name
  policy_arn = aws_iam_policy.sfn_access_handler.arn
}
