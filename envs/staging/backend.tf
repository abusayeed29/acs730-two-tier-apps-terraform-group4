
terraform {
  backend "s3" {
    bucket = "group4-staging-tfstate" #  change to your bucket
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
