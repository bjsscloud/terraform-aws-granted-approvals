resource "aws_kms_alias" "main" {
  name          = var.alias
  target_key_id = aws_kms_key.main.key_id
}

