#changes done by amir
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}
