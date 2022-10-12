resource "aws_kms_key" "main" {
  bypass_policy_lockout_safety_check = false
  deletion_window_in_days            = var.deletion_window
  description                        = local.csi
  enable_key_rotation                = true
  policy                             = data.aws_iam_policy_document.key.json
  tags                               = local.default_tags
}
