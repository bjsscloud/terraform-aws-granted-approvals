resource "aws_iam_role_policy_attachment" "sns_publish_lambda" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.sns_publish_lambda.arn
}
