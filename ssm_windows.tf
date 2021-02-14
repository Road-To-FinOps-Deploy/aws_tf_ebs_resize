resource "aws_ssm_document" "ssm_ebs_mapping_windows" {
  name          = "ssm_ebs_mapping_windows"
  document_type = "Command"

  content = <<DOC
  {
  "schemaVersion": "2.2",
  "description": "Map Disk Drives to EBS Volumes",
  "parameters": {
    "Message": {
      "type": "String",
      "description": "Example",
      "default": "Hello EC2 User"
    }
  },
  "mainSteps": [
    {
      "action": "aws:runPowerShellScript",
      "name": "example",
      "inputs": {
        "runCommand": [
          " # List the disks for NVMe volumes",
          "",
          "function Get-EC2InstanceMetadata {",
          " param([string]$Path)",
          " (Invoke-WebRequest -Uri 'http://169.254.169.254/latest/$Path').Content ",
          "}",
          "",
          "function GetEBSVolumeId {",
          " param($Path)",
          " $SerialNumber = (Get-Disk -Path $Path).SerialNumber",
          " if($SerialNumber -clike 'vol*'){",
          " $EbsVolumeId = $SerialNumber.Substring(0,20).Replace('vol','vol-')",
          " }",
          " else {",
          " $EbsVolumeId = $SerialNumber.Substring(0,20).Replace('AWS','AWS-')",
          " }",
          " return $EbsVolumeId",
          "}",
          "",
          "function GetDeviceName{",
          " param($EbsVolumeId)",
          " if($EbsVolumeId -clike 'vol*'){",
          " ",
          " $Device = ((Get-EC2Volume -VolumeId $EbsVolumeId ).Attachment).Device",
          " $VolumeName = ''",
          " }",
          " else {",
          " $Device = 'Ephemeral'",
          " $VolumeName = 'Temporary Storage'",
          " }",
          " Return $Device,$VolumeName",
          "}",
          "",
          "function GetDriveLetter{",
          " param($Path)",
          " $DiskNumber = (Get-Disk -Path $Path).Number",
          " if($DiskNumber -eq 0){",
          " $VirtualDevice = 'root'",
          " $DriveLetter = 'C'",
          " $PartitionNumber = (Get-Partition -DriveLetter C).PartitionNumber",
          " }",
          " else",
          " {",
          " $VirtualDevice = 'N/A'",
          " $DriveLetter = (Get-Partition -DiskNumber $DiskNumber).DriveLetter",
          " if(!$DriveLetter)",
          " {",
          " $DriveLetter = ((Get-Partition -DiskId $Path).AccessPaths).Split(',')[0]",
          " } ",
          " $PartitionNumber = (Get-Partition -DiskId $Path).PartitionNumber ",
          " }",
          " ",
          " return $DriveLetter,$VirtualDevice,$PartitionNumber",
          "",
          "}",
          "",
          "$Report = @()",
          "foreach($Path in (Get-Disk).Path)",
          "{",
          " $Disk_ID = ( Get-Partition -DiskId $Path).DiskId",
          " $Disk = ( Get-Disk -Path $Path).Number",
          " $EbsVolumeId = GetEBSVolumeId($Path)",
          " $Size =(Get-Disk -Path $Path).Size",
          " $DriveLetter,$VirtualDevice, $Partition = (GetDriveLetter($Path))",
          " $Device,$VolumeName = GetDeviceName($EbsVolumeId)",
          " $Disk = New-Object PSObject -Property @{",
          " Disk = $Disk",
          " Partitions = $Partition",
          " DriveLetter = $DriveLetter",
          " EbsVolumeId = $EbsVolumeId ",
          " Device = $Device ",
          " VirtualDevice = $VirtualDevice ",
          " VolumeName= $VolumeName",
          " }",
          " $Report += $Disk",
          "} ",
          "",
          "$Report | Sort-Object Disk | ConvertTo-Json",
          ""
        ]
      }
    }
  ]
}
DOC
}




resource "aws_ssm_document" "ssm_ebs_partition_windows" {
  name          = "ssm_ebs_partition_windows"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "partition Volumes",
    "mainSteps": [
      {
        "name": "PartitionVolumesMappingWindows",
        "action": "aws:runPowerShellScript",
        "precondition": {
          "StringEquals": [
            "platformType",
            "Windows"
          ]
        },
        "inputs": {
          "runCommand": [
            "Write-Verbose 'Startig to partition extension.'",
            "$MaxSize = (Get-PartitionSupportedSize -DriveLetter c).sizeMax",
            "Resize-Partition -DriveLetter c -Size $MaxSize"
           ]
        }
      }
    ]
  }
DOC
}

resource "aws_ssm_document" "ssm_Setup_windows" {
  name          = "ssm_SetupWindows"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "SetupWindows",
    "mainSteps": [
      {
        "name": "SetupWindows",
        "action": "aws:runPowerShellScript",
        "precondition": {
          "StringEquals": [
            "platformType",
            "Windows"
          ]
        },
        "inputs": {
          "runCommand": [
           "Read-S3Object -BucketName ${var.bucket_name} -Key AWS.EC2.Windows.CloudWatch.json -File 'C:\\Program Files\\Amazon\\SSM\\Plugins\\awsCloudWatch\\AWS.EC2.Windows.CloudWatch.json'",
           "Restart-Service AmazonSSMAgent"
           ]
        }
      }
    ]
  }
DOC
}