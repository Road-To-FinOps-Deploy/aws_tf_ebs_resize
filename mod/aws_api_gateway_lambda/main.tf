resource "aws_api_gateway_method" "method" {
  rest_api_id          = var.rest_api_id
  resource_id          = var.api_resource_id
  http_method          = var.http_method
  authorization        = "NONE"
  request_parameters   = var.method_request_params
  request_validator_id = var.request_validator_id
  api_key_required     = var.api_key_required
}



resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.api_resource_id
  http_method             = var.http_method
  integration_http_method = "POST"
  type                    = var.integration_type
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account_id}:function:${var.lambda_function_name}/invocations"
  credentials             = var.iam_role_arn_for_lambda
  depends_on              = [aws_api_gateway_method.method]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id        = var.rest_api_id
  resource_id        = var.api_resource_id
  http_method        = var.http_method
  status_code        = "200"
  response_templates = var.integration_response_templates
  depends_on         = [aws_api_gateway_integration.integration]
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id     = var.rest_api_id
  resource_id     = var.api_resource_id
  http_method     = var.http_method
  status_code     = "200"
  response_models = var.method_response_models
  depends_on      = [aws_api_gateway_integration_response.integration_response]
}
