locals {
  notifications_configuration = jsonencode({
    slack = {
      apiToken = "awsssm://${aws_ssm_parameter.secrets_notifications_slack_token.name}"
    }
  })
}
