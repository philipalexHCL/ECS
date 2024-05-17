terraform {
  backend "s3" {
    bucket         = "mybcktdt23"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_locks"

  }
}