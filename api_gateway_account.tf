# The API Gateway Settings apply across the entire AWS account
# and require globally a role to permit use of Cloudwatch Logs
# This AWS-enforced snowflake is configured here, with a role.
resource "aws_api_gateway_account" "main" {
  count = var.api_gateway_account_enabled ? 1 : 0

  cloudwatch_role_arn = aws_iam_role.api_gateway_logging[0].arn
}
