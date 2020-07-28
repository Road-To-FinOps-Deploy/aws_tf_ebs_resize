
module "sns-email-topic" {
  source        = "./mod/aws_sns_email_notifications"
  display_name  = "lambda_error_notification"
  service_name  = "finops_billing"
  email_address = var.alarm_email
  stack_name    = "BillingLambdasErrorsNotifications"
}

resource "aws_sns_topic" "statemachine_trigger" {
  name = "statemachine_trigger"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.statemachine_trigger.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.EXECUTION_STATE.arn
}