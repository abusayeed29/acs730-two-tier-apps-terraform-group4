variable "name_prefix"        { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "min_size"           { type = number }
variable "max_size"           { type = number }
variable "launch_template_id" { type = string }
variable "target_group_arn"   { type = string }
