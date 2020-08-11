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
