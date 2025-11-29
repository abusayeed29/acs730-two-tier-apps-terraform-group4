#####################################
# env/dev/outputs.tf
#####################################

output "vpc_id" {
  value       = module.networking.vpc_id
  description = "ID of the VPC"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the ALB"
}

output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Public IP of bastion host"
}

output "private_subnet_ids" {
  value       = module.networking.private_subnet_ids
  description = "Private subnet IDs used by the web tier"
}
