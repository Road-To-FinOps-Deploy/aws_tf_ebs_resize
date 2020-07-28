
# Automating Amazon EBS Volume-resizing with AWS Step Functions and AWS Systems Manager


## Prerec
* EC2 Role has access to cloud watch and SSM
* AWS.EC2.Windows.CloudWatch added to server  C:\Program Files\Amazon\SSM\Plugins\awsCloudWatch\
* Change Region if needed
* Run Powershell as administrator and run Restart-Service AmazonSSMAgent
* Update the Cloudwatch with the EC2 ID


## Deploy

have access to the account you wish to deploy in
terraoform init
terraform apply


## What does it do?
![Alt text](mod/stepfunctions_graph.png?raw=true)

This state machine is trigged by the custom cloud watch metric for low disk space avalible then:
* Pass in the instance ID from watch
* Runs SSM to get the volume ID and current size
* Increase by deafult 10% 
* Partitions the volume to be able to use the new size
* if over 100GB (deafult) will send an email


## To add
* linux 
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

## Troubleshooting
If your step function is failing saying the volume name is NA then made sure you enough permisson on the ec2
Check the ec2 role example in policies