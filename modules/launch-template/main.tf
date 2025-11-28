#####################################
# modules/launch-template/main.tf
#####################################

locals {
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd awscli
    systemctl enable httpd
    systemctl start httpd

    # Copy image from S3 (private bucket)
    aws s3 cp s3://${var.image_bucket_name}/flower.jpg /var/www/html/flower.jpg

    # Create index.html that displays the image
    cat <<HTML > /var/www/html/index.html
    <html>
    <head><title>${var.name_prefix} Web</title></head>
    <body style="text-align:center;">
      <h1>${var.name_prefix} Web Tier</h1>
      <p>Served from EC2 AutoScaling Group</p>
      <img src="flower.jpg" style="max-width:600px;">
    </body>
    </html>
HTML
  EOF
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-WebLT-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  # REQUIRED — EC2 needs permission to read from private S3 bucket

  # REQUIRED — enables SSH if needed
  key_name = var.key_name

  # Allow inbound port 80 from ALB SG
  vpc_security_group_ids = [var.web_sg_id]

  # EC2 user data
  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.name_prefix}-web"
      Environment = var.environment
      Project     = var.name_prefix
    }
  }
}
