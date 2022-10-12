output "key_arn" {
  value = aws_kms_key.main.arn
}

output "key_id" {
  value = aws_kms_key.main.key_id
}

output "admin_policy_arn" {
  value = aws_iam_policy.admin.arn
}

output "user_policy_arn" {
  value = aws_iam_policy.user.arn
}

