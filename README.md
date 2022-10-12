Granted Approvals
=================

Granted Approvals by CommonFate

* https://github.com/bjsscloud/terraform-aws-granted-approvals/
* https://github.com/common-fate/granted-approvals/
* https://commonfate.io/

Example Usage
-------------

### tfvars for component (root module)

```hcl
sso_granted = {
  enabled                = true
  administrator_group_id = "<Object ID of Azure AD Security Group for Granted Administrators>"
  azure_client_id        = "<IDP Syncer Azure App Registration Client ID>"
  azure_tenant_id        = "<Azure Tenant ID>"
  identity_provider_name = "<Descriptor for the Azure IDP (No spaces)>"
  identity_provider_type = "azure"
  saml_sso_metadata_url  = "https://login.microsoftonline.com/<Tenant ID>/federationmetadata/2007-06/federationmetadata.xml?appid=<Enterprise App ID>"
  sources_version        = "v0.5.0" # "dev/caef2f71a6cba469d1ff487a044b292c500db2ed"

  cognito_custom_image_base64 = "<Base64 Image Data>"
}
```

### Variables for component (root module)

```hcl
variable "sso_granted" {
  type        = map(any)
  description = "Configuration for Granted deployment"

  default = {
    enabled = false
  }
}
```

### Module call from component (root module), e.g. `components/sso/module_granted.tf`

```hcl
module "granted" {
  count  = var.sso_granted["enabled"] ? 1 : 0
  source = "bjsscloud/granted-approvals/aws"

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region

  aws_sso_identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
  aws_sso_instance_arn      = tolist(data.aws_ssoadmin_instances.main.arns)[0]

  public_hosted_zone_id = var.public_hosted_zone_id

  administrator_group_id    = lookup(var.sso_granted, "administrator_group_id", "granted_administrators")
  azure_client_id           = lookup(var.sso_granted, "azure_client_id", "")
  azure_tenant_id           = lookup(var.sso_granted, "azure_tenant_id", "")
  azure_email_identifier    = lookup(var.sso_granted, "azure_email_identifier", "mail")
  identity_provider_name    = lookup(var.sso_granted, "identity_provider_name", null)
  identity_provider_type    = lookup(var.sso_granted, "identity_provider_type", "cognito")
  saml_sso_metadata_content = lookup(var.sso_granted, "saml_sso_metadata_content", null)
  saml_sso_metadata_url     = lookup(var.sso_granted, "saml_sso_metadata_url", null)
  sources_version           = lookup(var.sso_granted, "sources_version", null)

  cognito_custom_image_file   = lookup(var.sso_granted, "cognito_custom_image_file", null)
  cognito_custom_image_base64 = lookup(var.sso_granted, "cognito_custom_image_base64", null)

  default_tags = local.default_tags
}
```

### `aws_ssoadmin_instances` Data Source in component (root module)

```hcl
data "aws_ssoadmin_instances" "main" {}
```

Configuration Steps for a complete Azure AD installation
========================================================

### 1. Prepare AAD Client Secret for Syncing Users & Groups

Based on documentation here: https://docs.commonfate.io/granted-approvals/providers/azure-ad

  1. https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade
  2. New Application: `AWS <Environment> Granted Directory Sync`
     * a. Single Tenant (This Organization Directory Only)
     * b. Click Register
  3. API Permissions → Add
     * a. Use Application permissions from Microsoft Graph
          - i. `User.Read.All`
          - ii. `Group.Read.All`
          - iii. `GroupMember.Read.All`
     * b. Click Add Permissions
  4. Click Grant Admin Consent - Or request Consent be granted from AAD Administrators
  5. Certificates and Secrets
     * a. New Client Secret: " AWS <Environment> Granted Directory Sync "
     * b. Retrieve "Value" for later writing to Parameter Store
  6. Store Application (Client) ID for use in tfvars: sso_granted["azure_client_id"]
  7. Store Tenant ID for use in tfvars: sso_granted["azure_tenant_id"]

### 2. Prepare AzureAd Enterprise Application

Based on documentation here: https://docs.commonfate.io/granted-approvals/providers/azure-ad

  1. https://portal.azure.com/#blade/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade
  2. Enterprise Applications → New → Create your own: " AWS <Environment> Granted SSO "
  3. Store Application ID for use in tfvars: sso_granted["saml_sso_metadata_url"] = https://login.microsoftonline.com/<TENANT ID>/federationmetadata/2007-06/federationmetadata.xml?appid=<APPLICATION ID>
  4. Set Reply URL and temporary Identifier:
     * a. Identifier: urn:amazon:cognito:sp:eu-west-2_CHANGEME
     * b. Reply URL.  Use  "i" if you are not passing a custom domain to Granted. Use "ii" if you are.
          - i. https://<project>-<environment>-sso-granted-web.auth.<REGION>.amazoncognito.com/saml2/idpresponse
          - ii. https://auth.granted.<ROOT DOMAIN NAME>/saml2/idpresponse
  5. Assign Groups (Create as necessary)
     * a. Group for Admins: e.g. EntApp-AWS-<Environment>-Granted-Admins
     * b. Group for User Access: e.g. Core-AAD-Guests
  6. Capture Admin Group Object ID for use in tfvars: sso_granted["administrator_group_id"]

### 3. Configure Terraform Environment

```hcl
sso_granted = {
  enabled                = true
  administrator_group_id = "<VALUE FROM STEP 2.6>"
  azure_client_id        = "<VALUE FROM STEP 1.6>"
  azure_tenant_id        = "<VALUE FROM STEP 1.7>"
  identity_provider_type = "azure"
  saml_sso_metadata_url  = "https://login.microsoftonline.com/a64cb840-fecf-45ea-a7e2-a7526e51be02/federationmetadata/2007-06/federationmetadata.xml?appid=<VALUE FROM STEP 2.3>"
  sources_version        = "v0.5.0" OR "dev/caef2f71a6cba469d1ff487a044b292c500db2ed"
}
```

### 4. Deploy Component (root module)

Presuming tfscaffold (https://github.com/tfutils/tfscaffold.git)

```bash
$ ./bin/terraform.sh -p <PROJECT> -g <GROUP> -e <ENVIRONMENT> -c sso -a apply
```

### 5. Update SAML Entity ID in AAD

  1. Update the `AWS <Environment> Granted SSO` Enterprise Application SAML Settings. Replace `CHANGEME` in Identitfier (Entity ID) with the value of the terraform output: `web_cognito_user_pool_id`

### 6. Configure Slack App

  1. Use the URL in the terraform output called `slack_app_create_url` to create a new Slack App
  2. Install to Workspace
  3. OAuth & Permisssions: Capture Bot User OAuth Token for use in Parameter Store

### 7. Write Secrets to Parameter Store

```bash
$ aws ssm put-parameter --name '/<PROJECT>-<ENVIRONMENT>-sso-granted/secrets/identity/token' --value '<VALUE FROM STEP 1.5.b>' --type SecureString --overwrite
$ aws ssm put-parameter --name '/<PROJECT>-<ENVIRONMENT>-sso-granted/secrets/notifications/slack/token' --value '<VALUE FROM STEP 7.3>' --type SecureString --overwrite
```
