module "kms" {
  source = "../kms"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region

  alias           = "alias/${local.csi}"
  deletion_window = "30"
  name            = "${var.module}-${var.function_name}"

  key_policy_documents = [ data.aws_iam_policy_document.kms.json ]

  default_tags = local.default_tags
}
