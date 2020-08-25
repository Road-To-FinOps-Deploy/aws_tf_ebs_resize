data "archive_file" "execution_state_zip" {
  type        = "zip"
  source_file = "${path.module}/source/execution_state/lambda.py"
  output_path = "${path.module}/output/execution_state.zip"
}

resource "aws_lambda_function" "EXECUTION_STATE" {
  filename         = "${path.module}/output/execution_state.zip"
  function_name    = "EXECUTION_STATE"
  role             = aws_iam_role.iam_role_lambda.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.execution_state_zip.output_base64sha256
  runtime          = "python3.6"
  memory_size      = "512"
  timeout          = "150"

  environment {
    variables = {
      STATE_MACHINE_ARN    = aws_sfn_state_machine.sfn_state_machine.id
      SSM_DOCUMENT_WINDOWS = aws_ssm_document.ssm_ebs_mapping_windows.name
      SSM_DOCUMENT_LINUX   = aws_ssm_document.ssm_ebs_mapping_linux.name
    }
  }
}


resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.EXECUTION_STATE.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.statemachine_trigger.arn
}


###########


data "archive_file" "modify_ebs_zip" {
  type        = "zip"
  source_file = "${path.module}/source/modify_ebs/lambda.py"
  output_path = "${path.module}/output/modify_ebs.zip"
}

resource "aws_lambda_function" "MODIFY_EBS" {
  filename         = "${path.module}/output/modify_ebs.zip"
  function_name    = "MODIFY_EBS"
  role             = aws_iam_role.iam_role_lambda.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.modify_ebs_zip.output_base64sha256
  runtime          = "python3.6"
  memory_size      = "512"
  timeout          = "250"
  environment {
    variables = {
      INCREASE_PERCENTAGE = var.increase_percentage
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_MODIFY_EBS" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.MODIFY_EBS.function_name
  principal     = "events.amazonaws.com"
  #source_arn    = "${aws_cloudwatch_event_rule.MODIFY_EBS_cloudwatch_rule.arn}"
}

################

data "archive_file" "execute_ssm_zip" {
  type        = "zip"
  source_file = "${path.module}/source/execute_ssm/lambda.py"
  output_path = "${path.module}/output/execute_ssm.zip"
}

resource "aws_lambda_function" "EXECUTE_SSM" {
  filename         = "${path.module}/output/execute_ssm.zip"
  function_name    = "EXECUTE_SSM"
  role             = aws_iam_role.iam_role_lambda.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.execute_ssm_zip.output_base64sha256
  runtime          = "python3.6"
  memory_size      = "512"
  timeout          = "150"
}

resource "aws_lambda_permission" "allow_cloudwatch_EXECUTE_SSM" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.EXECUTE_SSM.function_name
  principal     = "events.amazonaws.com"
}

##############

data "archive_file" "check_os_zip" {
  type        = "zip"
  source_file = "${path.module}/source/check_os/lambda.py"
  output_path = "${path.module}/output/check_os.zip"
}

resource "aws_lambda_function" "CHECK_OS" {
  filename         = "${path.module}/output/check_os.zip"
  function_name    = "CHECK_OS"
  role             = aws_iam_role.iam_role_lambda.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.check_os_zip.output_base64sha256
  runtime          = "python3.6"
  memory_size      = "512"
  timeout          = "150"
}

