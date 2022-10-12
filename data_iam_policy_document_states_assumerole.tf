data "aws_iam_policy_document" "states_assumerole" {
  statement {
    sid    = "AWSStatesAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "states.${var.region}.${var.aws_url_suffix}",
      ]
    }
  }
}
