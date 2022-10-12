resource "aws_iam_role" "sfn_access_handler" {
  name               = "${local.csi}-sfn-access_handler"
  assume_role_policy = data.aws_iam_policy_document.states_assumerole.json

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-sfn-access-handler"
    }
  )

  provisioner "local-exec" {
    command = "sleep 10"
  }
}
