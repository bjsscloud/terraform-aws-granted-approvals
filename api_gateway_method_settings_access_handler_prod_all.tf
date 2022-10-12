resource "aws_api_gateway_method_settings" "access_handler_prod_all" {
  rest_api_id = aws_api_gateway_rest_api.access_handler.id
  stage_name  = aws_api_gateway_stage.access_handler_prod.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
