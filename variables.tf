##
# Basic Required Variables for tfscaffold Modules
##

variable "project" {
  type        = string
  description = "The name of the tfscaffold project"
}

variable "environment" {
  type        = string
  description = "The name of the tfscaffold environment"
}

variable "component" {
  type        = string
  description = "The name of the tfscaffold component"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID (numeric)"
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "aws_partition" {
  type        = string
  description = "AWS Partition"
  default     = "aws"
}

variable "aws_url_suffix" {
  type        = string
  description = "AWS URL Suffix"
  default     = "amazonaws.com"
}

##
# tfscaffold variables specific to this module
##

variable "module" {
  type        = string
  description = "The variable encapsulating the name of this module"
  default     = "granted"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to all taggable resources within the component"
  default     = {}
}

##
# Variables specific to this module
##

# Deployment

variable "sources_s3_bucket_id" {
  type        = string
  description = "Location for upstream Granted releases"
  default     = "granted-releases-us-west-2"
}

variable "sources_version" {
  type        = string
  description = "Version of Granted Lambda Functions and Frontend Assets"
  default     = "v0.6.2"
}

# Custom (non-CloudFront) Domains

variable "public_hosted_zone_id" {
  type        = string
  description = "Zone ID of a Route53 Public Hosted Zone for a custom domain name"
  default     = null
}

# Slack

variable "slack_token_initial_secret_value" {
  type        = string
  description = "Initial Value for the SSM Parameter Store Parameter storing a Slack Secret"
  default     = "CHANGEME"
}

# Identity Provider (General)

variable "administrator_group_id" {
  type        = string
  description = "If not using Cognito, this must be overridden with a Group ID from your provider to grant administrative access"
  default     = "granted_administrators"
}

variable "identity_provider_type" {
  type        = string
  description = "identity provider: [cognito, okta, azure, google]. okta requires SamlSSOMetadataURL to be provided"
  default     = "cognito"
}

variable "idp_sync_schedule" {
  type        = string
  description = "An EventBridge Event Rule Schedule Expression for the IDP Sync Lambda Function"
  default     = "cron(0/5 * * * ? *)"
}

variable "cache_sync_schedule" {
  type        = string
  description = "An EventBridge Event Rule Schedule Expression for the Cache Sync Lambda Function"
  default     = "cron(0/5 * * * ? *)"
}

# Identity Provider (SAML - Azure/Okta)

variable "identity_provider_name" {
  type        = string
  description = "Custom name for the Cognito Identity Provider when using a SAML configuration"
  default     = null
}

variable "saml_sso_metadata_url" {
  type        = string
  description = "URL of XML Metadata file for SAML SSO"
  default     = null
}

variable "saml_sso_metadata_content" {
  type        = string
  description = "XML Metadata for SAML SSO"
  default     = null
}

variable "identity_token_initial_secret_value" {
  type        = string
  description = "Initial Value for the SSM Parameter Store Parameter storing an Identity Provider Secret"
  default     = "CHANGEME"
}

# Identity Provider (Azure)

variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID when provider_type = azure"
  default     = ""
}

variable "azure_client_id" {
  type        = string
  description = "Azure Client ID when provider_type = azure"
  default     = ""
}

variable "azure_email_identifier" {
  type        = string
  description = "Field in AzureAD being used for the e-mail claim, always guaranteed to contain an e-mail address"
  default     = "mail"
}

# Identity Provider (Okta)

variable "okta_org_url" {
  type        = string
  description = "Okta Org URL when provider_type = okta"
  default     = ""
}

# AWS Single Sign-On

variable "aws_sso_identity_store_id" {
  type        = string
  description = "AWS SSO Identity Store ID"
}

variable "aws_sso_instance_arn" {
  type        = string
  description = "AWS SSO Instance ARN"
}

variable "aws_sso_region" {
  type        = string
  description = "AWS SSO Instance region"
}

# AWS API Gateway

variable "api_gateway_account_enabled" {
  type        = bool
  description = "Whether to manage the API Gateway Account resource (API Gateway Logging Role configuration) for the whole AWS account"
  default     = true
}

# AWS Cognito

variable "web_cognito_allowed_oauth_scopes" {
  type        = list(string)
  description = "Allowed OAuth Scopes for Cognito, and used in the aws-exports.json frontend content"

  default = [
    "openid",
    "email",
    "profile",
  ]
}

variable "web_cognito_custom_css" {
  type        = string
  description = "Custom CSS for Cognito Login UI Customisation, when using a SAML configuration"
  default     = ".label-customizable {font-weight: 400;}"
}

variable "web_cognito_custom_image_base64" {
  type        = string
  description = "Custom Image as a base64 string for Cognito Login UI Customisation, when using a SAML configuration"
  default     = null
}

variable "web_cognito_custom_image_file" {
  type        = string
  description = "Custom Image as a path to a file for Cognito Login UI Customisation, when using a SAML configuration"
  default     = null
}

# Operational Constants

variable "event_bus_source_key" {
  type        = string
  description = "Unique key for event bus events related to this service"
  default     = "commonfate.io/granted"
}

variable "lambda_dlq_targets" {
  type        = list(map(string))
  description = "Targets to subscribe to the lambda SNS topic (usually DLQ)"
  default     = []
}

variable "lambda_function_log_retention_in_days" {
  type        = number
  description = "Number of days to retain Lambda Function logs in Cloudwatch"
  default     = 90
}

variable "s3_access_logs_s3_bucket_id" {
  type        = string
  description = "AWS S3 Bucket ID for S3 Server Access Logs"
  default     = null
}
