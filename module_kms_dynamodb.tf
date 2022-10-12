module "kms_dynamodb" {
  source = "./modules/kms"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  alias           = "alias/dynamodb/${local.csi}"
  deletion_window = "30"
  name            = "${var.module}-dynamodb"

  key_policy_documents = [ data.aws_iam_policy_document.kms_dynamodb.json ]

  default_tags = local.default_tags
}

