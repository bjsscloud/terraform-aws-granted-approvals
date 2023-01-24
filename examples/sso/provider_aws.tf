provider "aws" {
  region = var.region

  allowed_account_ids = [
    var.aws_account_id,
  ]
}

provider "aws" {
  region = var.aws_sso_region
  alias  = "sso"

  allowed_account_ids = [
    var.aws_account_id,
  ]
}


provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"

  allowed_account_ids = [
    var.aws_account_id,
  ]
}
