##
# Basic Required Variables for tfscaffold Components
##

variable "project" {
  type        = string
  description = "The tfscaffold project"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS Account ID (numeric)"
}

variable "region" {
  type        = string
  description = "The AWS Region"
}

variable "group" {
  type        = string
  description = "The group variables are being inherited from (often synonmous with account short-name)"
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment variables are being inherited from"
}

##
# tfscaffold variables specific to this component
##

# This is the only primary variable to have its value defined as
# a default within its declaration in this file, because the variables
# purpose is as an identifier unique to this component, rather
# then to the environment from where all other variables come.
variable "component" {
  type        = string
  description = "The variable encapsulating the name of this component"
  default     = "sso"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to all taggable resources within the component"
  default     = {}
}

##
# Granted
##

variable "root_domain_zone_id" {
  type        = string
  description = "AWS Route53 Public Hosted Zone ID. If provided will be used for a custom frontend domain for Granted Approvals"
  default     = null
}

# TODO: Implement strict typing with optional attributes
#sso_granted = {
#  enabled                   = true
#  administrator_group_id    = "string"
#  azure_client_id           = "string"
#  azure_tenant_id           = "string"
#  frontend_certificate_arn  = "string"
#  frontend_domain           = "string"
#  identity_provider_type    = "string"
#  saml_sso_metadata_content = "string"
#}
variable "sso_granted" {
  type       = map(any)
  description = "Configuration for Granted Approvals deployment"

  default = {
    enabled = false
  }
}

