terraform {
  backend "s3" {
    bucket = "group4-prod-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
