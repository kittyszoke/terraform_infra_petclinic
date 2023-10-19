# Subnets : public
resource "aws_subnet" "jack-subnet-public" {
  vpc_id = var.vpc_id
  cidr_block = "100.20.32.0/20"
  availability_zone = var.az-1
  map_public_ip_on_launch = true
  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

# Subnets : public 2
resource "aws_subnet" "jack-subnet-public-2" {
  vpc_id = var.vpc_id
  cidr_block = "100.20.160.0/20"
  availability_zone = var.az-2
  map_public_ip_on_launch = true
  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

# Subnets : private
resource "aws_subnet" "jack-subnet-private" { 
  vpc_id = var.vpc_id
  cidr_block = "100.20.48.0/20"
  availability_zone = var.az-1
  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

# Subnets : private 2
resource "aws_subnet" "jack-subnet-private-2" {
  vpc_id = var.vpc_id
  cidr_block = "100.20.112.0/20"
  availability_zone = var.az-2
  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

# Create Route Table
resource "aws_route_table" "jack-dev-routetable" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw
  }

  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

