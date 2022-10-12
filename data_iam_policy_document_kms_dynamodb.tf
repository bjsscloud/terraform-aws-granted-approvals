data "aws_iam_policy_document" "kms_dynamodb" {
  statement {
    sid    = "DelegateUseToIamViaDynamoDb"
    effect = "Allow"

    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:${var.aws_partition}:iam::${var.aws_account_id}:root",
      ]
    }

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"

      values = [
        "dynamodb.*.${var.aws_url_suffix}",
      ]
    }
  }
}
