terraform {
  backend "s3" {
    bucket         = "single-dev-demo"
    key            = "dev/01_networking/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dev-tfstate-lock"
    encrypt        = true
  }
}
