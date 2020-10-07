resource "aws_ssm_document" "ssm_ebs_mapping_windows" {
  name          = "ssm_ebs_mapping_windows"
  document_type = "Command"

  content = <<DOC
  {
  "schemaVersion": "2.2",
  "description": "Map Disk Drives to EBS Volumes",
  "mainSteps": [
    {
      "name": "DisksToVolumesMappingWindows",
      "action": "aws:runPowerShellScript",
      "precondition": {
        "StringEquals": [
          "platformType",
          "Windows"
        ]
      },
      "inputs": {
        "runCommand": [
          " Set-StrictMode -Version 2.0",
          " $ErrorActionPreference = 'Stop'",
          " function Get-EC2InstanceMetadata",
          " {",
          "     param([string]$Path)",
          "     $WebClient = New-Object System.Net.WebClient",
          "     $WebClient.DownloadString(\"http://169.254.169.254/latest/$Path\")",
          " }",
          " function Convert-SCSITargetIdToDeviceName",
          " {",
          "     param([int]$SCSITargetId)",
          "     If ($SCSITargetId -eq 0) {",
          "         return \"/dev/sda1\"",
          "     }",
          "     $deviceName = \"xvd\"",
          "     If ($SCSITargetId -gt 25) {",
          "         $deviceName += [char](0x60 + [int]($SCSITargetId / 26))",
          "     }",
          "     $deviceName += [char](0x61 + $SCSITargetId % 26)",
          "     return $deviceName",
          " }",
          " Try {",
          "     $InstanceId = Get-EC2InstanceMetadata \"meta-data/instance-id\"",
          "     $AZ = Get-EC2InstanceMetadata \"meta-data/placement/availability-zone\"",
          "     $Region = $AZ.Remove($AZ.Length - 1)",
          "     $BlockDeviceMappings = (Get-EC2Instance -Region $Region -Instance $InstanceId).Instances.BlockDeviceMappings",
          "     $VirtualDeviceMap = @{}",
          "     (Get-EC2InstanceMetadata \"meta-data/block-device-mapping\").Split(\"`n\") | ForEach-Object {",
          "         $VirtualDevice = $_",
          "         $BlockDeviceName = Get-EC2InstanceMetadata \"meta-data/block-device-mapping/$VirtualDevice\"",
          "         $VirtualDeviceMap[$BlockDeviceName] = $VirtualDevice",
          "         $VirtualDeviceMap[$VirtualDevice] = $BlockDeviceName",
          "      }",
          " }",
          " Catch {",
          "      Write-Host \"Could not access the AWS API, therefore, VolumeId is not available. Verify that you provided your access keys.\" -ForegroundColor Yellow",
          " }",
          " Get-WmiObject -Class Win32_DiskDrive | ForEach-Object {",
          "      $DiskDrive = $_",
          "      $Volumes = Get-WmiObject -Query \"ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($DiskDrive.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition\" | ForEach-Object {",
          "          $DiskPartition = $_",
          "          Get-WmiObject -Query \"ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($DiskPartition.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition\"",
          "      }",
          "      If ($DiskDrive.PNPDeviceID -like \"*PROD_PVDISK*\") {",
          "          $BlockDeviceName = Convert-SCSITargetIdToDeviceName($DiskDrive.SCSITargetId)",
          "          $BlockDevice = $BlockDeviceMappings | Where-Object { $_.DeviceName -eq $BlockDeviceName }",
          "          $VirtualDevice = If ($VirtualDeviceMap.ContainsKey($BlockDeviceName)) { $VirtualDeviceMap[$BlockDeviceName] } Else { $null }",
          "      } ElseIf ($DiskDrive.PNPDeviceID -like \"*PROD_AMAZON_EC2_NVME*\") {",
          "          $BlockDeviceName = Get-EC2InstanceMetadata \"meta-data/block-device-mapping/ephemeral$($DiskDrive.SCSIPort - 2)\"",
          "          $BlockDevice = $null",
          "          $VirtualDevice = If ($VirtualDeviceMap.ContainsKey($BlockDeviceName)) { $VirtualDeviceMap[$BlockDeviceName] } Else { $null }",
          "      } Else {",
          "          $BlockDeviceName = $null",
          "          $BlockDevice = $null",
          "          $VirtualDevice = $null",
          "      }",
          "      $Volumes | ForEach-Object {",
          "          $Vol = $_",
          "          New-Object PSObject -Property @{",
          "              Disk = $DiskDrive.Index;",
          "              PartitionSize = If ($Vol -eq $null) { \"N/A\" } Else { $Vol.Size };",
          "              DriveLetter = If ($Vol -eq $null) { \"N/A\" } Else { $Vol.DeviceID };",
          "              EbsVolumeId = If ($BlockDevice -eq $null) { \"N/A\" } Else { $BlockDevice.Ebs.VolumeId };",
          "              Device = If ($BlockDeviceName -eq $null) { \"N/A\" } Else { $BlockDeviceName };",
          "              VirtualDevice = If ($VirtualDevice -eq $null) { \"N/A\" } Else { $VirtualDevice };",
          "              VolumeName = If ($Vol -eq $null) { \"N/A\" } Else { $Vol.VolumeName };",
          "          }",
          "      }",
          " } | Sort-Object Disk | ConvertTo-Json"
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