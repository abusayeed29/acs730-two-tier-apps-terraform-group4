# this is test hello dhruv here
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-IGW"
  }
}


# Public_SN1
resource "aws_subnet" "public_sn1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_sn1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-Public-SN1"
  }
}

# Private_SN1
resource "aws_subnet" "private_sn1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_sn1_cidr
  availability_zone = var.az1

  tags = {
    Name = "${var.name_prefix}-Private-SN1"
  }
}

# Public_SN2
resource "aws_subnet" "public_sn2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_sn2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-Public-SN2"
  }
}

# Private_SN2 s
resource "aws_subnet" "private_sn2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_sn2_cidr
  availability_zone = var.az2

  tags = {
    Name = "${var.name_prefix}-Private-SN2"
  }
}

# NAT in Public_SN1
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sn1.id

  tags = {
    Name = "${var.name_prefix}-NATGW"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public RT
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_prefix}-Public-RT"
  }
}

resource "aws_route_table_association" "public_sn1_assoc" {
  subnet_id      = aws_subnet.public_sn1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_sn2_assoc" {
  subnet_id      = aws_subnet.public_sn2.id
  route_table_id = aws_route_table.public.id
}

# Private RT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name_prefix}-Private-RT"
  }
}

resource "aws_route_table_association" "private_sn1_assoc" {
  subnet_id      = aws_subnet.private_sn1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_sn2_assoc" {
  subnet_id      = aws_subnet.private_sn2.id
  route_table_id = aws_route_table.private.id
}
