#####################################
# env/dev/variables.tf
#####################################

variable "project_name" {
  description = "Name prefix for resources"
  type        = string
}

variable "env_name" {
  description = "Environment name (Dev/Stg/Prod)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

# VPC & Subnets
variable "vpc_cidr"         { type = string }
variable "public_sn1_cidr"  { type = string }
variable "private_sn1_cidr" { type = string }
variable "public_sn2_cidr"  { type = string }
variable "private_sn2_cidr" { type = string }

variable "az1" { type = string }
variable "az2" { type = string }

# EC2
variable "web_instance_type" {
  type        = string
  description = "Instance type for web servers"
}

variable "bastion_instance_type" {
  type        = string
  description = "Instance type for bastion host"
}

variable "min_size" {
  type        = number
  description = "Min instances in ASG"
}

variable "max_size" {
  type        = number
  description = "Max instances in ASG"
}

# Security
variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH to bastion"
}

# S3 & AMI
variable "image_bucket_name" {
  type        = string
  description = "Bucket storing web image"
}

variable "image_key" {
  type        = string
  description = "Object key for web image"
}

variable "ami_id" {
  type        = string
  description = "AMI for Amazon Linux 2 (or similar)"
}
