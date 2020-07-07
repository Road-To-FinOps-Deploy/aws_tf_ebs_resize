data "aws_caller_identity" "current" {
}


terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = "~> 2.67"

  }
}
