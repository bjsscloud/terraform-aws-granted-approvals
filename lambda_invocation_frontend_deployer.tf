resource "aws_lambda_invocation" "frontend_deployer" {
  function_name = module.lambdacron_frontend_deployer.lambda_function_name
  qualifier     = module.lambdacron_frontend_deployer.lambda_function_version

  input = jsonencode({
    cloudfrontDistributionId = aws_cloudfront_distribution.frontend.id
    sourceS3BucketId         = var.sources_s3_bucket_id
    targetS3BucketId         = module.s3bucket_frontend.id
    version                  = var.sources_version
  })

  # Technically this already applies to the input variables
  # but it doesn't hurt to be explicit
  triggers = {
    lambda_function_version  = module.lambdacron_frontend_deployer.lambda_function_version,
    cloudfrontDistributionId = aws_cloudfront_distribution.frontend.id
    sourceS3BucketId         = var.sources_s3_bucket_id
    targetS3BucketId         = module.s3bucket_frontend.id
    version                  = var.sources_version
  }

  depends_on = [
    module.lambdacron_frontend_deployer, # Depend on the whole module, not just the function
  ]
}
