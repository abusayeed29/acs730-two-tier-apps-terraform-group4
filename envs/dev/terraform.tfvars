########################################
# env/dev/terraform.tfvars
########################################

project_name = "TwoTierApp"
env_name     = "Dev"
region       = "us-east-1"

# From your diagram
vpc_cidr = "192.168.0.0/16"

public_sn1_cidr  = "192.168.1.0/24"
private_sn1_cidr = "192.168.11.0/24"
public_sn2_cidr  = "192.168.2.0/24"
private_sn2_cidr = "192.168.12.0/24"

az1 = "us-east-1a"
az2 = "us-east-1b"

web_instance_type     = "t3.micro"
bastion_instance_type = "t3.micro"

min_size = 2
max_size = 4

# For bastion – tighten this in real life
allowed_ssh_cidr = "0.0.0.0/0"

image_bucket_name = "group4-dev-web-images"
image_key         = "flower.jpg"

# Example Amazon Linux 2 AMI in us-east-1  (double-check!)
# ami-0c02fb55956c7d316 is common, but you should verify in console.
ami_id = "ami-0fa3fe0fa7920f68e"
