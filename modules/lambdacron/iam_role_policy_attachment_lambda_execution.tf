resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}
