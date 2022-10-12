data "aws_iam_policy_document" "rest_api_access_handler_invoke" {
  statement {
    sid    = "AllowInvokeAccessHandlerApi"
    effect = "Allow"

    actions = [
      "execute-api:Invoke",
    ]

    resources = [
      "${aws_api_gateway_rest_api.access_handler.execution_arn}/*/*/*",
    ]
  }
}
