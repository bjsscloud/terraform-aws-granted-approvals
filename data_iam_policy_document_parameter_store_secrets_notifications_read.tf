data "aws_iam_policy_document" "parameter_store_secrets_notifications_read" {
  statement {
    sid    = "AllowReadNotificationsSecrets"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = [
      aws_ssm_parameter.secrets_notifications_slack_token.arn,
    ]
  }

  statement {
    sid    = "AllowUseNotificationsSecretsReadSsmKmsKey"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = [
      module.kms_ssm.key_arn,
    ]
  }

  statement {
    sid    = "AllowDelegationOfNotificationSecretsReadKmsKeyToAwsService"
    effect = "Allow"

    actions = [
      "kms:CreateGrant",
    ]

    resources = [
      module.kms_ssm.key_arn,
    ]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = [
        "true",
      ]
    }
  }
}

