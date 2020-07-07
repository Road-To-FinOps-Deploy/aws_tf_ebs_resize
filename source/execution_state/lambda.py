import boto3
import os
import json
import logging

log = logging.getLogger()
ARN_of_state_machine = os.environ["STATE_MACHINE_ARN"]
SSM_Document_name = os.environ["SSM_DOCUMENT"]


def lambda_handler(event, context):

    Message = event["Records"][0]["Sns"]["Message"]
    log.info(Message)
    tmp = json.loads(Message)
    Dimensions = tmp["Trigger"]["Dimensions"][0]

    Instance_ID = Dimensions.get("value")
    log.info(Instance_ID)
    executionArn = state(Instance_ID)
    log.info(f"State Machine {ARN_of_state_machine} triggered, {executionArn}")


def state(Instance_ID):

    sf = boto3.client("stepfunctions")
    input = '{"Instance_ID" : "%s", "SSM_Document_Name" : "%s"}' % (
        Instance_ID,
        SSM_Document_name,
    )  # "{\\\"Instance_ID\\\" : \\\"%s\\\"}" %Instance_ID
    print(input)
    response = sf.start_execution(stateMachineArn=ARN_of_state_machine, input=input)
    executionArn = response["executionArn"]
    return executionArn
