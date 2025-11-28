#####################################
# env/dev/main.tf
#####################################

locals {
  name_prefix = "${var.project_name}-${var.env_name}"
}

# 1) Networking (VPC, subnets, NAT, routes)
module "networking" {
  source = "../../modules/networking"

  name_prefix      = local.name_prefix
  vpc_cidr         = var.vpc_cidr
  public_sn1_cidr  = var.public_sn1_cidr
  private_sn1_cidr = var.private_sn1_cidr
  public_sn2_cidr  = var.public_sn2_cidr
  private_sn2_cidr = var.private_sn2_cidr
  az1              = var.az1
  az2              = var.az2
}

# 2) IAM for web instances (S3 read)
module "iam" {
  source = "../../modules/iam"

  name_prefix       = local.name_prefix
  image_bucket_name = var.image_bucket_name
}

# 3) Security groups (ALB, Bastion, Web)
module "security" {
  source = "../../modules/security"

  name_prefix      = local.name_prefix
  vpc_id           = module.networking.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# 4) ALB in public subnets
module "alb" {
  source = "../../modules/alb"

  name_prefix       = local.name_prefix
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}

# 5) Launch template for web instances
module "launch_template" {
  source = "../../modules/launch-template"
  name_prefix          = local.name_prefix
  ami_id               = var.ami_id
  instance_type        = var.web_instance_type
  web_sg_id            = module.security.web_sg_id
  image_bucket_name    = var.image_bucket_name
  image_key            = var.image_key
  environment          = var.env_name
  key_name             = "vockey"
}

# 6) Auto Scaling Group (web tier in private subnets)
module "asg" {
  source = "../../modules/asg"

  name_prefix        = local.name_prefix
  private_subnet_ids = module.networking.private_subnet_ids
  min_size           = var.min_size
  max_size           = var.max_size
  launch_template_id = module.launch_template.launch_template_id
  target_group_arn   = module.alb.target_group_arn
}

# 7) Bastion host in Public_SN2
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = module.networking.public_sn2_id
  vpc_security_group_ids      = [module.security.bastion_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "${local.name_prefix}-Bastion"
  }
}
