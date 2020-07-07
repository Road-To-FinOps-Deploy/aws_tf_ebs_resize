import boto3
import time
import os
import json
import logging

log = logging.getLogger()


def lambda_handler(event, context):
    print(event)
    client = boto3.client("ssm")
    Instance_Id = event.get("Instance_ID")
    DocumentName = event.get("SSM_Document_Name")  # os.environ["SSM_DOCUMENT_NAME"]

    response = client.send_command(
        InstanceIds=[Instance_Id], DocumentName=DocumentName  #'ssm_ebs_mapping'
    )

    Command_Id = response["Command"]["CommandId"]
    time.sleep(50)

    response = client.get_command_invocation(
        CommandId=Command_Id, InstanceId=Instance_Id
    )
    print(response)
    if DocumentName == "ssm_ebs_mapping_windows":
        if response["Status"] == "Success":
            output = json.loads(response["StandardOutputContent"])
            Device = output["Device"]
            EbsVolumeId = output["EbsVolumeId"]
            DriveLetter = output["DriveLetter"]
            print(
                f"Outputinfo Device={Device}, EbsVolumeId={EbsVolumeId},DriveLetter={DriveLetter}"
            )
            log.info(
                f"Output from command {Command_Id} info Device={Device}, EbsVolumeId={EbsVolumeId},DriveLetter={DriveLetter}"
            )
            return {
                "Instance_ID": Instance_Id,
                "Device": Device,
                "EbsVolumeId": EbsVolumeId,
                "DriveLetter": DriveLetter,
            }
        else:
            log.error(f"Please check command results Command_Id={Command_Id}")
    else:
        if response["Status"] == "Success":

            log.info(f"CommandId: {Command_Id}")
            return {"CommandId": Command_Id}
