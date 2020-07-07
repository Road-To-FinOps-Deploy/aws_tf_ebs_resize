variable "display_name" {
  type        = string
  description = "SNS topic display name"
}

variable "email_address" {
  type        = string
  description = "SNS topic subscription endpoint - must be email address"
}

variable "stack_name" {
  type        = string
  description = "Cloudformation stack name"
}

variable "service_name" {
  type        = string
  description = "Name of service SNS subscription will belong to"
}

variable "protocol" {
  default     = "email"
  description = "SNS topic subscription protocal type"
}


