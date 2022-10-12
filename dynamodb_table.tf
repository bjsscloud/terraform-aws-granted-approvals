resource "aws_dynamodb_table" "main" {
  name = local.csi

  billing_mode = "PAY_PER_REQUEST"

  point_in_time_recovery {
    enabled = true
  }

  hash_key  = "PK"
  range_key = "SK"

  dynamic "attribute" {
    for_each = [
      "PK",
      "SK",
      "GSI1PK",
      "GSI1SK",
      "GSI2PK",
      "GSI2SK",
      "GSI3PK",
      "GSI3SK",
      "GSI4PK",
      "GSI4SK",
    ]

    content {
      name = attribute.value
      type = "S"
    }
  }

  dynamic "global_secondary_index" {
    for_each = [
      "1",
      "2",
      "3",
      "4",
    ]

    content {
      name            = "GSI${global_secondary_index.value}"
      hash_key        = "GSI${global_secondary_index.value}PK"
      range_key       = "GSI${global_secondary_index.value}SK"
      projection_type = "ALL"
    }
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = module.kms_dynamodb.key_arn
  }

  tags = local.default_tags
}
