data "aws_iam_policy_document" "sso_admin" {
  statement {
    sid    = "AllowAdminSso"
    effect = "Allow"

    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateRole",
      "iam:GetRole",
      "iam:GetSAMLProvider",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:PutRolePolicy",
      "iam:UpdateSAMLProvider",
      "identitystore:ListUsers",
      "organizations:DescribeAccount",
      "organizations:DescribeOrganization",
      "organizations:ListAccounts",
      "sso:CreateAccountAssignment",
      "sso:DeleteAccountAssignment",
      "sso:DescribeAccountAssignmentCreationStatus",
      "sso:DescribeAccountAssignmentDeletionStatus",
      "sso:DescribePermissionSet",
      "sso:ListAccountAssignments",
      "sso:ListPermissionSets",
      "sso:ListTagsForResource",
      "organizations:ListAccountsForParent",
      "organizations:ListOrganizationalUnitsForParent",
      "organizations:ListRoots",
      "organizations:ListTagsForResource"
    ]

    resources = [
      "*",
    ]
  }
}
