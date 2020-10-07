resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = "AWS.EC2.Windows.CloudWatch.json"
  source = "${template_file.policy.rendered}"
}


resource "template_file" "policy" {
  template = "${path.module}/policies/AWS.EC2.Windows.CloudWatch.json"

  vars = {
    var_region = "${var.region}"
  }
}