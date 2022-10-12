locals {
  # Compound Scope Identifier
  csi = replace(
    format(
      "%s-%s-%s-%s-%s",
      var.project,
      var.environment,
      var.component,
      var.module,
      var.function_name,
    ),
    "_",
    "",
  )

  # CSI for use in resources with an account namespace, eg IAM roles
  csi_account = replace(
    format(
      "%s-%s-%s-%s-%s-%s",
      var.project,
      var.region,
      var.environment,
      var.component,
      var.module,
      var.function_name,
    ),
    "_",
    "",
  )

  # CSI for use in resources with a unique namespace, i.e. S3 Buckets
  csi_global = replace(
    format(
      "%s-%s-%s-%s-%s-%s-%s",
      var.project,
      var.aws_account_id,
      var.region,
      var.environment,
      var.component,
      var.module,
      var.function_name,
    ),
    "_",
    "",
  )

  default_tags = merge(
    var.default_tags,
    {
      Module = var.module
      Name   = local.csi
    },
  )

  archive_path = "${path.root}/work/${local.csi_global}/function.zip"

  # Annoyingly the "aws_lambda_layer_version" data source doesn't return
  # anything for the LambdaInsightsExtension, so we have to hack it like this:

  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Lambda-Insights-extension-versionsx86-64.html
  lambda_insight_layer_arns = {
    "x86-64" = {
      "1.0.143.0" = {
        "us-east-1"      = "arn:aws:lambda:us-east-1:580247275435:layer:LambdaInsightsExtension:21"
        "us-east-2"      = "arn:aws:lambda:us-east-2:580247275435:layer:LambdaInsightsExtension:21"
        "us-west-1"      = "arn:aws:lambda:us-west-1:580247275435:layer:LambdaInsightsExtension:20"
        "us-west-2"      = "arn:aws:lambda:us-west-2:580247275435:layer:LambdaInsightsExtension:21"
        "af-south-1"     = "arn:aws:lambda:af-south-1:012438385374:layer:LambdaInsightsExtension:13"
        "ap-east-1"      = "arn:aws:lambda:ap-east-1:519774774795:layer:LambdaInsightsExtension:13"
        "ap-south-1"     = "arn:aws:lambda:ap-south-1:580247275435:layer:LambdaInsightsExtension:21"
        "ap-northeast-3" = "arn:aws:lambda:ap-northeast-3:194566237122:layer:LambdaInsightsExtension:2"
        "ap-northeast-2" = "arn:aws:lambda:ap-northeast-2:580247275435:layer:LambdaInsightsExtension:20"
        "ap-southeast-1" = "arn:aws:lambda:ap-southeast-1:580247275435:layer:LambdaInsightsExtension:21"
        "ap-southeast-2" = "arn:aws:lambda:ap-southeast-2:580247275435:layer:LambdaInsightsExtension:21"
        "ap-northeast-1" = "arn:aws:lambda:ap-northeast-1:580247275435:layer:LambdaInsightsExtension:32"
        "ca-central-1"   = "arn:aws:lambda:ca-central-1:580247275435:layer:LambdaInsightsExtension:20"
        "eu-central-1"   = "arn:aws:lambda:eu-central-1:580247275435:layer:LambdaInsightsExtension:21"
        "eu-west-1"      = "arn:aws:lambda:eu-west-1:580247275435:layer:LambdaInsightsExtension:21"
        "eu-west-2"      = "arn:aws:lambda:eu-west-2:580247275435:layer:LambdaInsightsExtension:21"
        "eu-south-1"     = "arn:aws:lambda:eu-south-1:339249233099:layer:LambdaInsightsExtension:13"
        "eu-west-3"      = "arn:aws:lambda:eu-west-3:580247275435:layer:LambdaInsightsExtension:20"
        "eu-north-1"     = "arn:aws:lambda:eu-north-1:580247275435:layer:LambdaInsightsExtension:20"
        "me-south-1"     = "arn:aws:lambda:me-south-1:285320876703:layer:LambdaInsightsExtension:13"
        "sa-east-1"      = "arn:aws:lambda:sa-east-1:580247275435:layer:LambdaInsightsExtension:20"
      }
    }
  }

  lambda_insights_layer = var.use_lambda_insights ? [
    local.lambda_insight_layer_arns["x86-64"]["1.0.143.0"][var.region],
  ] : []

  lambda_layers = concat(
    local.lambda_insights_layer,
    var.lambda_layers
  )
}
