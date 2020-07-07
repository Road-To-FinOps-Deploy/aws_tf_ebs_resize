data "template_file" "cloudformation_sns_stack" {
  template = file("${path.module}/cloud_formation/email-sns-stack.json.tpl")

  vars = {
    display_name  = "${var.service_name}-${var.display_name}"
    email_address = var.email_address
    protocol      = var.protocol
  }
}

resource "aws_cloudformation_stack" "sns-topic" {
  name          = var.stack_name
  template_body = data.template_file.cloudformation_sns_stack.rendered

  tags = {
    Origin       = "Terraform"
    Project_Name = var.service_name
  }
}

