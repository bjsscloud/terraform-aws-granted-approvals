resource "aws_ssm_parameter" "secrets_notifications_slack_token" {
  name   = "/${local.csi}/secrets/notifications/slack/token"
  type   = "SecureString"
  value  = var.slack_token_initial_secret_value
  key_id = module.kms_ssm.key_arn

  lifecycle {
    ignore_changes = [
      value,
    ]
  }

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-secrets-notifications-slack-token",
    }
  )
}
