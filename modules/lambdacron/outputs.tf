output "lambda_function_name" {
  value = aws_lambda_function.main.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.main.arn
}

output "lambda_function_version" {
  value = aws_lambda_function.main.version
}

output "lambda_function_environment" {
  value = aws_lambda_function.main.environment
}

output "iam_role_name" {
  value = aws_iam_role.main.name
}

output "iam_role_arn" {
  value = aws_iam_role.main.arn
}

output "sns_topic_arn" {
  value = var.enable_dlq ? aws_sns_topic.main[0].arn : null
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.main.name
}

output "lambda_function_invoke_arn" {
  value = aws_lambda_function.main.invoke_arn
}
