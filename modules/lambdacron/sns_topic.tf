resource "aws_sns_topic" "main" {
  count = var.enable_dlq ? 1 : 0

  name              = local.csi
  kms_master_key_id = module.kms.key_arn
}
