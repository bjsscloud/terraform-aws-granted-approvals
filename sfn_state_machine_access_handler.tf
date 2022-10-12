resource "aws_sfn_state_machine" "access_handler" {
  name = local.csi

  definition = local.sfn_state_machine_definition

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sfn_access_handler.arn}:*"
    include_execution_data = true
    level                  = "ALL" # "ERROR"
  }

  role_arn = aws_iam_role.sfn_access_handler.arn

  tracing_configuration {
    enabled = true
  }

  type = "STANDARD"

  tags = local.default_tags

  depends_on = [
    aws_iam_role_policy_attachment.sfn_access_handler_sfn_access_handler,
  ]
}
