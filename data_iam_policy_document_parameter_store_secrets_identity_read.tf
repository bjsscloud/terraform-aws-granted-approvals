data "aws_iam_policy_document" "parameter_store_secrets_identity_read" {
  statement {
    sid    = "AllowReadIdentitySecrets"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = [
      aws_ssm_parameter.secrets_identity_token.arn,
    ]
  }

  statement {
    sid    = "AllowUseIdentitySecretsReadSsmKmsKey"
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
    sid    = "AllowDelegationOfIdentitySecretsReadKmsKeyToAwsService"
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
