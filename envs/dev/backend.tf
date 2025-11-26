terraform {
  backend "s3" {
    bucket = "group4-dev-tfstate"   # change to your bucket
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
