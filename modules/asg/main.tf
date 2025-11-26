resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.name_prefix}-WebASG"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.min_size
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-WebInstance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
