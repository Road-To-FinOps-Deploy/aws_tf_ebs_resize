resource "aws_ssm_document" "ssm_ebs_mapping_linux" {
  name          = "ssm_ebs_mapping_linux"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Map Disk Drives to EBS Volumes linux",
    "mainSteps": [
      {
        "name": "DisksToVolumesMappingLinux",
        "action": "aws:runShellScript",
        "precondition": {
          "StringEquals": [
            "platformType",
            "Linux"
          ]
        },
        "inputs": {
          "runCommand": 
            [
            "aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) --region eu-west-1"
            ]
        }
      }
    ]
  }
DOC
}


resource "aws_ssm_document" "ssm_ebs_partition_linux" {
  name          = "ssm_ebs_partition_linux"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "partition Volumes",
    "mainSteps": [
      {
        "name": "PartitionVolumesMappingLinux",
        "action": "aws:runShellScript",
        "precondition": {
          "StringEquals": [
            "platformType",
            "Linux"
          ]
        },
        "inputs": {
          "runCommand": 
            [
            "sudo growpart /dev/xvda 1"
            ]
        }
      }
    ]
  }
DOC
}

resource "aws_ssm_document" "ssm_linux_setup" {
  name          = "ssm_linux_setup"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "ssm_linux_setup",
    "mainSteps": [
      {
        "name": "ssm_linux_setup",
        "action": "aws:runShellScript",
        "precondition": {
          "StringEquals": [
            "platformType",
            "Linux"
          ]
        },
        "inputs": {
          "runCommand": 
            [
            "cd /home/ec2-user",
            "sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64",
            "curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O",
            "unzip CloudWatchMonitoringScripts-1.2.2.zip && \\",
            "rm CloudWatchMonitoringScripts-1.2.2.zip && \\",
            "cd aws-scripts-mon",
            "./mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --mem-used --mem-avail"
            ]
        }
      }
    ]
  }
DOC
}





  
  
