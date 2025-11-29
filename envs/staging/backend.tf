
terraform {
  backend "s3" {
    bucket = "group4-staging-tfstate" #  change to your bucket
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
<<<<<<< HEAD
=======

>>>>>>> e26ce97ba8d25f4c3fe798f03784f4c842f8004f
