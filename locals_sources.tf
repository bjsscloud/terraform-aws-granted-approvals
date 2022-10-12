locals {
  frontend_assets_key_prefix = "${var.sources_version}/frontend-assets"

  sources_filenames = {
    "v0.4.0" = {
      access_handler    = "a540fe3ca727a888e8c6a6123e996effc3a47f292955789fad21b1ac7663a6cb"
      approvals         = "1c57d712f0dd6e60268ae6b72720a9a05e34a00041ed450e00b318b550880453"
      event_handler     = "3092b40e76d02291ab4b184cc47041fb189bf6b921368671b2f1ad2d0c722618"
      frontend_deployer = "72c0f116ddb199ba49d141190ff0a462fe828fdd068797e37af71e6eeb329159"
      granter           = "dd1de9c47109dc2ae14b14bdc7ec9c30c193677e1919173ab1d793d96b8bde0a"
      idp_sync          = "a3f7712beb1b2247c4a532aa9ef8eb60aa25ffdf2157a957ea86c07151390adb"
      slack_notifier    = "775e02fba408a7022cfa5b5e84e7bc9ee86fc36001fff7f471a87fc9e9b8e4ac"
      webhook_handler   = "0214544cdff9bff9a3458346f1dfa058088a85abf11db2259e7d4e22479c6de2"
    }

    "v0.5.0" = {
      access_handler    = "7585b89a0867c91a0948d76252c29f9552dabad3e945ff464dfa32fcd106b6b5"
      approvals         = "2d6e236390b00c011d44bdb297432f02c2f18194a57d56b668a82159cb28fee5"
      event_handler     = "e3ca28b213bfa6ce4f0fc6c34eec408d4062b106d30ca39720a894c86839a45e"
      frontend_deployer = "d0fd250540e1a0dcb6b7b85e8be7574b1f25c48363caf46b66eaf842de91ea8a"
      granter           = "5ca430b393ffe7dc8a30d6d89e36602d7ee26d9c74d5450fe78d306eab26b4ac"
      slack_notifier    = "6d6794a66f8fd1095a55c35653137b01612f49c8d07bc6b16db0484ae60daf02"
      idp_sync          = "2b34a2ef5f61c1c8fd80e5d0c10f3242e8fb71e94edc26a0a93cd66be7f1210c"
      webhook_handler   = "dada168434aef9094f58fb10f5e10a951d8f0db1a862ceb4f6853c1b5f824c8b"
    }

    "dev/caef2f71a6cba469d1ff487a044b292c500db2ed" = {
      access_handler    = "8b28296f64bc81b4c4f15c31248da75dd493a012bf8b16961f28dc1b15e79899"
      approvals         = "9c4adca8298b521f29e4859309c28db34b36f4d4619ce69c318bd666024f3844"
      event_handler     = "8704333e90bb7bb6b3247ced432bdab480f91a82603d642412c4cdca21c30c1c"
      frontend_deployer = "9db5c490116eb7c41612e9053a4116725d4eb3c8a552d1c658478d834cf6d3f6"
      granter           = "c9c921e341a5892179e175e557b859c5c25727b09641215bce44465a02b63647"
      slack_notifier    = "436e1221a1d426ca2583313fed894777f392d1d16b2253b9b3203f9993446233"
      idp_sync          = "99fef7fdd509fdad755d4e8efb9d954945c36d206b63ba732bb2711679a6def3"
      webhook_handler   = "9e313e0227117a3167d69bdffe69e7e88a71cccca254b4e8e7827c14b77f0339"
    }
  }
}
