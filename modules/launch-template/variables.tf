variable "name_prefix"          { type = string }
variable "ami_id"               { type = string }
variable "instance_type"        { type = string }
variable "web_sg_id"            { type = string }
# variable "iam_instance_profile" { type = string }
variable "image_bucket_name"    { type = string }
variable "image_key"            { type = string }

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}
