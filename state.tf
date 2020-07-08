resource "aws_sfn_state_machine" "sfn_state_machine" {
  name       = "ebs_resize_state_machine"
  role_arn   = aws_iam_role.iam_role_for_state.arn
  definition = <<EOF
  {
    "StartAt": "CHECK_OS",
    "States": {
      "CHECK_OS": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.CHECK_OS.arn}",
        "Next": "ChoiceStateoverOS",
        "ResultPath": "$.OS_Result",
        "Catch": [
            {
               "ErrorEquals": ["States.ALL"],
               "Next": "FailState"
            }
         ]
      },
      "ChoiceStateoverOS": {
        "Type": "Choice",
        "Choices": [
          {
            "Variable": "$.OS_Result",
            "StringEquals": "windows",
            "Next": "SSM_GET_MAPPING"
          },
          {
            "Variable": "$.OS_Result",
            "StringEquals": "linux",
            "Next": "FailState"
          }
        ]
      },
      "SSM_GET_MAPPING": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.EXECUTE_SSM.arn}",
        "Next": "MODIFY_EBS",
        "ResultPath": "$.SSM_Result",
        "Catch": [
            {
               "ErrorEquals": ["States.ALL"],
               "Next": "FailState"
            }
         ]
      },
      "MODIFY_EBS": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.MODIFY_EBS.arn}",
        "Next": "SSM_PARTITION",
        "ResultPath": "$.MODIFY_EBSResult",
        "Parameters": {
          "Device.$": "$.SSM_Result.Device",
          "EbsVolumeId.$": "$.SSM_Result.EbsVolumeId",
          "DriveLetter.$": "$.SSM_Result.DriveLetter"
        },
        "Catch": [
          {
            "ErrorEquals": ["States.TaskFailed"],
            "Next": "FailState"
          }
        ]
      },
      "SSM_PARTITION": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.EXECUTE_SSM.arn}",
        "Next": "ChoiceStateover100email",
        "ResultPath": "$.SSM_PARTITION_Result",
        "Parameters": {
          "SSM_Document_Name": "${aws_ssm_document.ssm_ebs_partition_windows.name}",
          "Instance_ID.$": "$.SSM_Result.Instance_ID"
        },
        "Catch": [
            {
               "ErrorEquals": ["States.ALL"],
               "Next": "FailState"
            }
         ]
      },
      "ChoiceStateover100email": {
        "Type": "Choice",
        "Choices": [
          {
            "Variable": "$.MODIFY_EBSResult.NewSize",
            "NumericGreaterThanEquals": ${var.size_to_case_alert},
            "Next": "PublishSNS"
          },
          {
            "Variable": "$.MODIFY_EBSResult.NewSize",
            "NumericLessThan": ${var.size_to_case_alert},
            "Next": "SuccessState"
          }
        ]
      },
      "PublishSNS": {
        "Type": "Task",
        "Resource": "arn:aws:states:::sns:publish",
        "ResultPath": "$.PublishSNS",
        "Parameters": {
          "TopicArn": "${module.sns-email-topic.arn}",
          "Message": {
            "Device.$": "$.SSM_Result.Device",
            "EbsVolumeId.$": "$.SSM_Result.EbsVolumeId",
            "DriveLetter.$": "$.SSM_Result.DriveLetter",
            "NewInstnaceSize.$":"$.MODIFY_EBSResult.NewSize"
          }
        },
        "Next": "SuccessState",
        "Catch": [
          {
            "ErrorEquals": [
              "States.ALL"
            ],
            "Next": "FailState"
          }
        ]
      },
      "FailState": {
        "Type": "Fail"
      },
      "SuccessState": {
        "Type": "Succeed"
      }
    }
  }
EOF
}