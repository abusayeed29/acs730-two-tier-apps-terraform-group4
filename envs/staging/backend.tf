terraform {
  backend "s3" {
    bucket = "group4-staging-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
