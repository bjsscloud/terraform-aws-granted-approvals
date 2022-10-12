resource "aws_iam_role_policy_attachment" "insights_logs" {
  count      = var.use_lambda_insights ? 1 : 0
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.lambda_insights[0].arn
}
