resource "aws_iam_role" "iam_role_lambda" {
  name               = "rightsize_role_lambda"
  assume_role_policy = file("${path.module}/policies/LambdaAssume.pol")
}

resource "aws_iam_role_policy" "iam_role_policy_lambda" {
  name   = "rightsize_policy_lambda"
  role   = aws_iam_role.iam_role_lambda.id
  policy = file("${path.module}/policies/LambdaExecution.pol")
}

resource "aws_iam_role" "iam_role_for_state" {
  name = "iam_role_for_state"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Team = "FinOps"
  }
}



resource "aws_iam_role_policy" "for_state_policy" {
  name = "for_state_policy"
  role = aws_iam_role.iam_role_for_state.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "lambda:InvokeFunction",
          "sns:Publish"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}



resource "aws_iam_policy" "ec2_policy_ebs_reszier" {
  name        = "ec2_policy_ebs_reszier"
  policy = file("${path.module}/policies/ec2_ebs_policy.pol")
}