resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.root_resource_id}"
  http_method = "${var.get_data_http}"
  integration_http_method = "POST"
  type = "AWS"
  uri = "${var.test_lambda_invoke_arn}"
}