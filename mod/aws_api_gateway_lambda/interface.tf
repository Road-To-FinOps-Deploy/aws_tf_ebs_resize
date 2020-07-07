variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "Region for deployment"
}

variable "account_id" {
  type        = string
  description = "ID of the account for deployment"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the lambda function to trigger with the API endpoint"
}

variable "rest_api_id" {
  type        = string
  description = "ID of the Rest API gateway"
}

variable "api_resource_id" {
  type        = string
  description = "ID of the API resource"
}

variable "method_request_params" {
  type        = map
  default     = {}
  description = "Additional request parameters to input with the request"
}

variable "http_method" {
  type        = string
  description = "HTTP method for the API call (eg POST/GET/PUT)"
}

variable "iam_role_arn_for_lambda" {
  type        = string
  default     = ""
  description = "ARN for both the lambda function and the API gateway"
}

variable "integration_type" {
  type        = string
  default     = "AWS"
  description = "Type of integration to lambda endpoint"
}

variable "integration_response_templates" {
  type        = map
  description = "Map of the response templates"
}

variable "method_response_models" {
  type        = map
  description = "Map of the response models."
}

variable "api_key_required" {
  type        = string
  default     = false
  description = "Boolean as to whether the api method requires an API Key"
}

variable "request_validator_id" {
  type        = string
  description = "ID of the Request Validator for API method"
}
