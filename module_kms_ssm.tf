module "kms_ssm" {
  source = "./modules/kms"

  project        = var.project
  environment    = var.environment
  component      = var.component
  aws_account_id = var.aws_account_id
  region         = var.region
  aws_partition  = var.aws_partition
  aws_url_suffix = var.aws_url_suffix

  alias           = "alias/ssm/${local.csi}"
  deletion_window = "30"
  name            = "${var.module}-ssm"

  default_tags = local.default_tags
}

