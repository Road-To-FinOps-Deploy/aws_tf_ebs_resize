terraform {
  backend "s3" {
    bucket   = "sg-backup-bucket-sandbox"
    key      = "resize/terraform.tfstate"
    region   = "eu-west-1"
    role_arn = "arn:aws:iam::324382802360:role/SSOAdmin"
    encrypt  = "true"
  }
}

