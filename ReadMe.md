
# Automating Amazon EBS Volume-resizing with AWS Step Functions and AWS Systems Manager

This can be used for windows or linux instances. Use vars to choose which one.

## Prerec
### Windows:
* In the Console go to 'AWS Systems Manager'
* Click on 'Documents'
* Run the 'ssm_SetupWindows' against the Windows instance you wish to monitor




### Linux
* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html
* sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64
* curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
* unzip CloudWatchMonitoringScripts-1.2.2.zip && \
  rm CloudWatchMonitoringScripts-1.2.2.zip && \
  cd aws-scripts-mon
* ./mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --mem-used --mem-avail
or to use ``crontab -e`` and paste>  */5 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-used-incl-cache-buff --mem-util --disk-space-util --disk-path=/ --from-cron
Notes you exit by doing esc, :wq!


## Usage

module "aws_tf_ebs_resize" {
  source = "/aws_tf_ebs_resize"
  alarm_email = "example@email.com"
  InstanceId = "i-1234567890"
  bucket_name = "Your bucket name"
}

## Deploy

have access to the account you wish to deploy in
terraoform init
terraform apply


## Optional Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm\_email| email address of person to alert if gb goes over 100| string | `""` | yes |
| InstanceId | The id of the instance you wish to use| string | `""` | yes |
| size\_to\_case\_alert | At what GB size would you like to be notified | `"100"` | no |
| increase\_percentage | How big of increments to increase by| string | `"0.1"` | no |
| threshold | How high does the volumes utilised space need to be to trigger the alarm| string | `"75"` | no |
| region | Deployment region| string | `"eu-west-1"` | no |
| namespace | The custom namespace in metrics| string | `"Windows/Default"` | no |
| metric_name | The metric the alarm is watching| string | `"FreeDiskPercentage"` | no |



## What does it do?
![Alt text](mod/stepfunctions_graph.png?raw=true)

This state machine is trigged by the custom cloud watch metric for low disk space avalible then:
* Pass in the instance ID from watch
* Runs SSM to get the volume ID and current size
* Increase by deafult 10% 
* Partitions the volume to be able to use the new size
* if over 100GB (deafult) will send an email
* increase must be bigger than 1 on size of volume


## To add

* mutliple volumes
* pass letter of volume into partition
* tag snapshot
* s3 upload of file for ec2
* interagration into chat e.g. teams, slack
* prvisoinsed IOPs

Supporting links:
https://aws.amazon.com/blogs/storage/automating-amazon-ebs-volume-resizing-with-aws-step-functions-and-aws-systems-manager/
https://stackoverflow.com/questions/37441225/how-to-monitor-free-disk-space-at-aws-ec2-with-cloud-watch-in-windows
https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html
https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-windows-volumes.html

https://forums.aws.amazon.com/thread.jspa?start=25&threadID=310713&tstart=0
https://n2ws.com/blog/how-to-guides/how-to-increase-the-size-of-an-aws-ebs-cloud-volume-attached-to-a-linux-machine
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html

## Troubleshooting
If your step function is failing saying the volume name is NA then made sure you enough permisson on the ec2
Check the ec2 role example in policies

### Manule setup of json file
* https://stackoverflow.com/questions/37441225/how-to-monitor-free-disk-space-at-aws-ec2-with-cloud-watch-in-windows
* EC2 Role has access to cloud watch, SSM and S3
#### Manule
* Copy from polciies folder AWS.EC2.Windows.CloudWatch.json added to server  C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\

#### AWS CLI
* ```aws s3 cp s3://<bucketname>/AWS.EC2.Windows.CloudWatch.json C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json```
 
* Change Region if needed
* Run Powershell as administrator and run 
```Restart-Service AmazonSSMAgent```
* Update the Cloudwatch with the EC2 ID