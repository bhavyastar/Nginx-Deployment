#  Define main VPC
resource "aws_vpc" "vpc_ngx" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ngx_value"
  }
}

# Public subnet setup
resource "aws_subnet" "ngx_public_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_ngx.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "ngx_public_subnet-${count.index}"
  }
}

# Private subnet setup
resource "aws_subnet" "ngx_private_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_ngx.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.availability_zones))
  map_public_ip_on_launch = false
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "ngx_private_subnet-${count.index}"
  }
}

# Internet Gateway creation

resource "aws_internet_gateway" "ngx_igw" {
  vpc_id = aws_vpc.vpc_ngx.id

  tags = {
    Name = "ngx_igw"
  }
}

# NAT Gateway per AZ

resource "aws_nat_gateway" "ngx_nat" {
  count      = length(var.availability_zones)
  subnet_id  = element(aws_subnet.ngx_public_subnet.*.id, count.index)
  allocation_id = aws_eip.ngx_nat[count.index].id
  depends_on = [aws_internet_gateway.ngx_igw]

  tags = {
    Name = "nat-gateway-${count.index}"
  }
}

# Allocate EIP for NAT

resource "aws_eip" "ngx_nat" {
  count     = length(var.availability_zones)
  vpc       = true
}

# Public route table setup
resource "aws_route_table" "ngx_public_rt" {
  vpc_id = aws_vpc.vpc_ngx.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngx_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Private route table setup

resource "aws_route_table" "ngx_private_rt" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.vpc_ngx.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngx_nat[count.index].id
  }

  tags = {
    Name = "privateroutetable-${count.index}"
  }
}
# Associate public subnets

resource "aws_route_table_association" "ngx_public_rta" {
  count          = length(aws_subnet.ngx_public_subnet.*.id)
  subnet_id      = aws_subnet.ngx_public_subnet[count.index].id
  route_table_id = aws_route_table.ngx_public_rt.id
}

# Associate private subnets

resource "aws_route_table_association" "ngx_private_rta" {
  count          = length(aws_subnet.ngx_private_subnet.*.id)
  subnet_id      = aws_subnet.ngx_private_subnet[count.index].id
  route_table_id = aws_route_table.ngx_private_rt[count.index].id
}

# ALB security group setup


resource "aws_security_group" "ngx_alb_sg" {
  name        = "ngx_alb-security-group"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.vpc_ngx.id

# HTTP and HTTPS ingress


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
}

ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ALB Security Group"
  }
}