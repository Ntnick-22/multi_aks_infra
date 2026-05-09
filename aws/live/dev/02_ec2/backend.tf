terraform {
  backend "s3" {
    bucket         = "single-dev-demo"
    key            = "dev/02_ec2/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dev-tfstate-lock"
    encrypt        = true
  }
}
