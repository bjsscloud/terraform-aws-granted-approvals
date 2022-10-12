resource "aws_s3_object" "frontend_aws_exports_json" {
  key    = "${local.frontend_assets_key_prefix}/aws-exports.json"
  bucket = module.s3bucket_frontend.id

  content = jsonencode({
    API = {
      endpoints = [
        {
          endpoint = local.approvals_api_url
          name     = "approvals"
          region   = var.region
        }
      ]
    }

    Auth = {
      mandatorySignIn     = true
      region              = var.region
      userPoolId          = aws_cognito_user_pool.web.id
      userPoolWebClientId = local.web_cognito_user_pool_client_id

      oauth = {
        domain          = local.web_cognito_user_pool_domain
        redirectSignIn  = "https://${local.frontend_domain}"
        redirectSignOut = "https://${local.frontend_domain}"
        responseType    = "code"
        scope           = var.web_cognito_allowed_oauth_scopes
      }

      cookieStorage = {
        domain = local.frontend_domain
      }
    }
  })

  tags = merge(
    local.default_tags,
    {
      Name = "${local.csi}-frontend-aws-exports-json"
    }
  )
}
