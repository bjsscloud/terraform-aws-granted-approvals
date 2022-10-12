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

##
# tfscaffold variables specific to this module
##

variable "module" {
  type        = string
  description = "The variable encapsulating the name of this module"
  default     = "s3bucket"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to all taggable resources within the component"
  default     = {}
}

##
# Variables specific to this module
##

variable "bucket_key_enabled" {
  type        = bool
  description = "Boolean to toggle bucket key enablement"
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Boolean to toggle force destroy of bucket. Defaults to true; should be changed in exceptional circumstances"
  default     = true
}

variable "name" {
  type        = string
  description = "The variable encapsulating the name of this bucket"
}

variable "policy_documents" {
  type        = list(string)
  description = "A list of JSON policies to use to build the bucket policy"
  default     = []
}

variable "acl" {
  type        = string
  description = "ACL to set on the bucket. Defaults to private"
  default     = "private"
}

variable "lifecycle_rules" {
  type = object({
    prefix = string

    noncurrent_version_transition = list(object({
      days          = string
      storage_class = string
    }))

    transition = list(object({
      days          = string
      storage_class = string
    }))

    noncurrent_version_expiration = object({
      days = string
    })

    expiration = object({
      days = string
    })
  })

  description = "Object representing the lifecycle rules of the bucket"
  default     = null
}

variable "public_access" {
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })

  description = "Object representing the public access rules of the bucket"

  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

variable "bucket_logging_target" {
  type        = map(string)
  description = "Map of S3 bucket access logging target properties"
  default     = {}

  # Expected value:
  # {
  #   bucket = "my_bucket"
  #   prefix = "custom_prefix" // optional, defaults to name of bucket
  # }
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of default encryption KMS key for this bucket. If omitted, will use AES256"
  default     = null
}

variable "versioning" {
  type        = bool
  description = "Toggle for versioning the bucket. Defaults to true"
  default     = true
}

variable "object_ownership" {
  type        = string
  description = "Ownership of objects written to the bucket"
  default     = "BucketOwnerEnforced"
}
