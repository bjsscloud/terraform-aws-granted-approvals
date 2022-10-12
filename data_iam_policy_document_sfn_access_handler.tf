data "aws_iam_policy_document" "sfn_access_handler" {
  statement {
    sid    = "AllowWriteLogs"
    effect = "Allow"

    actions = [
      # This is trash - hopefully one day it can be better
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:DescribeLogGroups",
      "logs:DescribeResourcePolicies",
      "logs:GetLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:UpdateLogDelivery",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "AllowPublishToSNSTopic"
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      module.lambdacron_granter.lambda_function_arn
    ]
  }
}
