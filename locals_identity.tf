locals {
  identity_configuration = jsonencode({
    azure = {
      tenantId        = var.azure_tenant_id
      clientId        = var.azure_client_id
      clientSecret    = "awsssm://${aws_ssm_parameter.secrets_identity_token.name}"
      emailIdentifier = var.azure_email_identifier
    }

    okta = {
      apiToken = "awsssm://${aws_ssm_parameter.secrets_identity_token.name}"
      orgUrl   = var.okta_org_url
    }
  })
}
