data "aws_iam_policy_document" "aws_access_manage" {
  statement {
    sid    = "AllowReadGrantedProvidersSecrets"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = [
      format(
        "arn:%s:ssm:%s:%s:parameter/granted/providers/*",
        var.aws_partition,
        var.region,
        var.aws_account_id,
      )
    ]
  }

  statement {
    sid    = "AllowBroadOrgManagement"
    effect = "Allow"

    actions = [
      "identitystore:ListUsers",
      "organizations:DescribeAccount",
      "organizations:DescribeOrganization",
      "organizations:ListAccounts",
      "sso:CreateAccountAssignment",
      "sso:DeleteAccountAssignment",
      "sso:DescribePermissionSet",
      "sso:ListAccountAssignments",
      "sso:ListPermissionSets",
      "sso:ListTagsForResource",
      "states:DescribeExecution", # TODO: Target sfn state machine
      "states:GetExecutionHistory",
      "states:StartExecution",
      "states:StopExecution",
      "states:StopExecution",
      "sts:AssumeRole", # TODO: Query this!
    ]

    resources = [
      "*",
    ]
  }
}

