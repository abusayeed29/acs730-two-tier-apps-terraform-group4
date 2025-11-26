output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_sn1.id,
    aws_subnet.public_sn2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_sn1.id,
    aws_subnet.private_sn2.id
  ]
}

output "public_sn2_id" {
  value       = aws_subnet.public_sn2.id
  description = "Subnet ID for Public_SN2 (bastion)"
}
