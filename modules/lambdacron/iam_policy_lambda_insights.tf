resource "aws_iam_policy" "lambda_insights" {
  count       = var.use_lambda_insights ? 1 : 0
  name        = "${local.csi_account}-lambda-insights"
  description = "Insights policy for ${var.function_name} Lambda"
  policy      = data.aws_iam_policy_document.lambda_insights.json
}
