resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = var.object_ownership
  }

  depends_on = [ aws_s3_bucket_acl.main ]
}
