# TODO: Scope this down!
data "aws_iam_policy_document" "sns_publish" {
  statement {
    sid    = "AllowSnsPublish"
    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    resources = [
      "*",
    ]
  }
}
