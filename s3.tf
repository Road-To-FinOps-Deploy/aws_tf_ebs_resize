resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = "AWS.EC2.Windows.CloudWatch.json"
  source = "${path.module}/policies/AWS.EC2.Windows.CloudWatch.json"
}