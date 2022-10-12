data "aws_iam_policy_document" "assumerole_sso_admin" {
  statement {
    sid    = "AllowPrincipalsAssumeRoleForSsoAdminRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"

      identifiers = [
        module.lambdacron_access_handler.iam_role_arn,
        module.lambdacron_granter.iam_role_arn,
      ]
    }
  }
}
