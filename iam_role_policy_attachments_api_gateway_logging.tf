resource "aws_iam_role_policy_attachment" "api_gateway_logging_api_gateway_push_to_cloudwatch_logs" {
  count = var.api_gateway_account_enabled ? 1 : 0

  role       = aws_iam_role.api_gateway_logging[0].name
  policy_arn = "arn:${var.aws_partition}:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
