resource "aws_s3_bucket" "main" {
  bucket        = var.name
  force_destroy = var.force_destroy

  tags = local.default_tags
}
