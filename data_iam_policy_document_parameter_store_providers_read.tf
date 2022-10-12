data "aws_iam_policy_document" "parameter_store_providers_read" {
  statement {
    sid    = "AllowReadProvidersParameters"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = [
      "arn:${var.aws_partition}:ssm:${var.region}:${var.aws_account_id}:parameter/granted/providers/*",
    ]
  }

  statement {
    sid    = "AllowUseProvidersReadSsmKmsKey"
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
    sid    = "AllowDelegationOfKmsKeyToAwsService"
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
