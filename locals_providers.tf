locals {
  provider_configuration = jsonencode({
    "aws-sso" = {
      uses = "commonfate/aws-sso@v2"

      with = {
        identityStoreId = var.aws_sso_identity_store_id
        instanceArn     = var.aws_sso_instance_arn
        region          = var.region
        ssoRoleArn      = aws_iam_role.sso_admin.arn
      }
    }
  })
}
