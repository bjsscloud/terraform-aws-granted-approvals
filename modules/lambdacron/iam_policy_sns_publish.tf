resource "aws_iam_policy" "sns_publish_lambda" {
  name        = "${local.csi_account}-sns-publish-lambda"
  description = "SNS Publishing policy for ${var.function_name} Lambda"
  policy      = data.aws_iam_policy_document.sns_publish_lambda.json
}
