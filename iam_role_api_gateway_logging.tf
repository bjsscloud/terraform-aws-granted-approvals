resource "aws_iam_role" "api_gateway_logging" {
  count = var.api_gateway_account_enabled ? 1 : 0

  name               = "${local.csi}-apigw-logging"
  assume_role_policy = data.aws_iam_policy_document.apigateway_assumerole[0].json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-apigw-logging"
    }
  )

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
