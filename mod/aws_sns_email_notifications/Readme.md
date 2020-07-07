# sns_email (out of band terraform work around)

## Summary

Terraform supports most of the AWS SNS resource options you'll need sometimes you'll want to set up a notification topic that uses the email or email-json protocols. When using either of those an email is sent to the given address that needs to be confirmed out of bounds, not for terraform however, this module is a thin wrapper to expose the sns arn.

## Usage

```
module "admin-sns-email-topic" {
    source = "......."
    display_name  = "Sensible Name"
    project_name = "project_name"
    email_address = "admin@example.org"
    stack_name    = "admin-sns-email"
}
```
The argument, Protocol has a sensible default of email however could be emailjson for example

## Terraform Version Compatibility
 
| Module Version | Terraform Version |
| -------------- | ----------------- |
| 1.0.0          | 0.12.XX           |
| v0.5           | 0.11.XX           |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.63 |
| template | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.63 |
| template | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| display\_name | SNS topic display name | `string` | n/a | yes |
| email\_address | SNS topic subscription endpoint - must be email address | `string` | n/a | yes |
| protocol | SNS topic subscription protocal type | `string` | `"email"` | no |
| service\_name | Name of service SNS subscription will belong to | `string` | n/a | yes |
| stack\_name | Cloudformation stack name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | SNS topic AWS ARN |