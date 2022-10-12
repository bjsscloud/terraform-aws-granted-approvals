resource "aws_iam_policy" "lambda_execution" {
  name        = "${local.csi_account}-lambda-execution"
  description = "Execution policy for ${var.function_name} Lambda"
  policy      = data.aws_iam_policy_document.lambda_execution.json
}
