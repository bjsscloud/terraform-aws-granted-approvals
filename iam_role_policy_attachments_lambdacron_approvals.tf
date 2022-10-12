resource "aws_iam_role_policy_attachment" "lambdacron_approvals_kms_api_pagination_user" {
  role       = module.lambdacron_approvals.iam_role_name
  policy_arn = module.kms_api_pagination.user_policy_arn
}
