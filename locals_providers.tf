locals {
  COMMONFATE_PROVIDER_CONFIGuration = jsonencode({
    "aws-sso" = {
      uses = "commonfate/aws-sso@v2"

      with = {
        identityStoreId = var.aws_sso_identity_store_id
        instanceArn     = var.aws_sso_instance_arn
        region          = var.aws_sso_region
        ssoRoleArn      = aws_iam_role.sso_admin.arn
      }
    }
  })
}
