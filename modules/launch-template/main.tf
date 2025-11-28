#####################################
# modules/launch-template/main.tf
#####################################

locals {
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    echo "<html><h1>${var.name_prefix} Web Tier</h1><p>App is running</p></html>" > /var/www/html/index.html
  EOF
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-WebLT-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  # iam_instance_profile {
  #   name = "LabRole"
  # }

  # Security group for web instances (must allow 80 from ALB SG)
  vpc_security_group_ids = [var.web_sg_id]

  # Base64-encoded user data for Amazon Linux
  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"

   tags = {
      Name        = "${var.name_prefix}-web"
      Environment = var.environment
      Project     = var.name_prefix
      key_name    = var.key_name
    }
  }
}
