data "aws_iam_policy_document" "parameter_store_secrets_identity_read_write" {
  statement {
    sid    = "AllowReadWriteIdentitySecrets"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:PutParameter",
    ]

    resources = [
      aws_ssm_parameter.secrets_identity_token.arn,
    ]
  }

  statement {
    sid    = "AllowUseIdentitySecretsReadWriteSsmKmsKey"
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
    sid    = "AllowDelegationOfIdentitySecretsReadWriteKmsKeyToAwsService"
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
