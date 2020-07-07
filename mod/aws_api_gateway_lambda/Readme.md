# AWS API Gateway Lambda

## Summary
This module is used to create an api resource within the API gateway

## This module provides the following
 - api gateway method
 - api gateway integration
 - api gateway integration response
 - api gateway method response

## Usage
```
module "aws_api_gateway_lambda" {
  source                                       = "git::https://terraform-readonly:T87kN3x90yu@stash.customappsteam.co.uk/scm/ter/aws_api_gateway_lambda.git"
  region                                       = "${var.aws_region}"
  http_method                                  = "POST"
  account_id                                   = "${var.account_id}"
  lambda_function_name                         = "LambdaFunctionName"
  iam_role_arn_for_lambda                      = "${var.iam_role_for_lambda}"
  rest_api_id                                  = "${aws_api_gateway_rest_api.TeenTech.id}"
  integration_type                             = "AWS_PROXY"
  method_request_params                        = {
    "method.request.querystring.query_string"  = true
  }
  integration_response_templates               = {
    "application/json" = ""
  }
  method_response_models                       = {
    "application/json" = "Empty"
  }
  api_resource_id                              = "${aws_api_gateway_resource.register_resource.id}"
  request_validator_id                         = "${aws_api_gateway_request_validator.request_validator.id}"
}
```

## Optional Args

 - region
 - method_request_params
 - iam_role_arn_for_lambda
 - integration_type
 - api_key_required
