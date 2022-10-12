locals {
  slack_app_config = {
    display_information = {
      name             = local.csi
      description      = "Granted Privileged Identity Management for ${local.csi}"
      background_color = "#26223a"
    }

    features = {
      bot_user = {
        display_name  = local.csi
        always_online = false
      }
    }

    oauth_config = {
      scopes = {
        bot = [
          "channels:read",
          "chat:write",
          "groups:read",
          "im:write",
          "usergroups:read",
          "users.profile:read",
          "users:read",
          "users:read.email",
        ]
      }
    }

    settings = {
      interactivity = {
        is_enabled  = true
        request_url = "${local.approvals_api_url}webhook/v1/slack/interactivity"
      }

      org_deploy_enabled     = false
      socket_mode_enabled    = false
      token_rotation_enabled = false
    }
  }
}
