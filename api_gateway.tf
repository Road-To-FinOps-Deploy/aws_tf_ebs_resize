module aws_api_gateway_lambda {
  source                  = "./mod/aws_api_gateway_lambda"
  region                  = var.region
  http_method             = "POST"
  account_id              = data.aws_caller_identity.current.account_id
  lambda_function_name    = aws_lambda_function.EXECUTION_STATE.function_name
  iam_role_arn_for_lambda = aws_iam_role.iam_role_lambda.arn
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  integration_type        = "AWS_PROXY"
  method_request_params = {
    "method.request.querystring.query_string" = true
  }
  integration_response_templates = {
    "application/json" = ""
  }
  method_response_models = {
    "application/json" = "Empty"
  }
  api_resource_id      = aws_api_gateway_resource.register_resource.id
  request_validator_id = aws_api_gateway_request_validator.gateway_request_validator.id
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "api_gateway"
}


resource "aws_api_gateway_resource" "register_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "api_gateway"
}


resource "aws_api_gateway_request_validator" "gateway_request_validator" {
  name                        = "gateway_request_validator"
  rest_api_id                 = aws_api_gateway_rest_api.api_gateway.id
  validate_request_body       = true
  validate_request_parameters = true
}