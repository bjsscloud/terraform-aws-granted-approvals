resource "aws_iam_policy" "xray" {
  name        = "${local.csi_account}-xray"
  description = "XRay policy for ${var.function_name} Lambda"
  policy      = data.aws_iam_policy_document.xray.json
}
