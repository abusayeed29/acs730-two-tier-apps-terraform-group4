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

cat << 'HTML' > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="shortcut icon" href="#">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <title>Welcome to flower template</title>
</head>
<style media="screen">
  body {
          background-color: #818181ff;
          font-size: 50pt;
          color: white;
    }
</style>
<body>
    <div class="container-fluid">
      <div id="one" class="text-center">
        <span>"Whats my url?"</span>
      </div>
      <div class="row">
        <div class="col-md-6 text-center">
          <a href="#"><img src="https://group4-dev-web-image.s3.us-east-1.amazonaws.com/flower.jpg" width="400" height="400" alt="..." class="img-rounded"></a>
        </div>
        <div class="col-md-6 text-center">
          <a href="#"><img src="https://group4-dev-web-image.s3.us-east-1.amazonaws.com/flower2.jpg" width="400" height="400" alt="..." class="img-rounded"></a>
        </div>
      </div>
    </div>
<script>
    $('#one span').text(window.location.href);
</script>
</body>
</html>
HTML
EOF
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-WebLT-"
  image_id      = var.ami_id
  instance_type = var.instance_type

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
