data "aws_iam_policy_document" "admin" {
  policy_id = "${local.csi}-admin"

  statement {
    sid    = "AllowKeyAdmin"
    effect = "Allow"

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = [
      aws_kms_key.main.arn,
      aws_kms_alias.main.arn,
    ]
  }
}

