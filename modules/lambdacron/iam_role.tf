resource "aws_iam_role" "main" {
  name               = var.absolute_function_name ? var.function_name : local.csi_account
  assume_role_policy = data.aws_iam_policy_document.lambda_assumerole.json

  # Le sigh
  provisioner "local-exec" {
    command = "sleep 10"
  }
}
