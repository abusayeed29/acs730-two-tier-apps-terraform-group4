locals {
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd awscli
    systemctl enable httpd
    systemctl start httpd

    aws s3 cp s3://${var.image_bucket_name}/${var.image_key} /var/www/html/${var.image_key}

    cat <<HTML >/var/www/html/index.html
    <html>
      <head><title>${var.name_prefix} Web</title></head>
      <body style="text-align:center;">
        <h1>${var.name_prefix} Web Tier</h1>
        <p>Served from a private EC2 instance behind the ALB.</p>
        <img src="${var.image_key}" style="max-width:600px;" />
      </body>
    </html>
HTML
  EOF
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-WebLT-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  vpc_security_group_ids = [var.web_sg_id]

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.name_prefix}-WebInstance"
    }
  }
}
