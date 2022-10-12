output "acl" {
  value = aws_s3_bucket_acl.main.acl
}

output "arn" {
  value = aws_s3_bucket.main.arn
}

output "bucket" {
  value = aws_s3_bucket.main.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.main.bucket_regional_domain_name
}

output "hosted_zone_id" {
  value = aws_s3_bucket.main.hosted_zone_id
}

output "id" {
  value = aws_s3_bucket.main.id
}

output "policy" {
  value = aws_s3_bucket_policy.main.policy
}

output "region" {
  value = aws_s3_bucket.main.region
}
