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
            ["lsblk"
            "curl http://169.254.169.254/latest/meta-data/block-device-mapping/ephemeral0"
            ]
        }
      }
    ]
  }
DOC
}