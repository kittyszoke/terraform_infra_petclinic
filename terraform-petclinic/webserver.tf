# Petclinic / Public Subnet settings


# Associate subnet with route table
resource "aws_route_table_association" "jack-subnet-1a-association" {
  subnet_id      = aws_subnet.jack-subnet-public.id
  route_table_id = aws_route_table.jack-dev-routetable.id
}


# Create NACL 

resource "aws_network_acl" "jack-nacl-public" {
  vpc_id = var.vpc_id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

# Create Bastion EC2 

resource "aws_instance" "jack-petclinic" {
  ami                    = var.image
  instance_type          = var.inst_type
  availability_zone      = "eu-west-1a"
  key_name               = var.ssh_key
  subnet_id              = aws_subnet.jack-subnet-public.id
  vpc_security_group_ids = [aws_security_group.jack-sg-allow-web.id]
  
  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}


# Create target 1 EC2 

resource "aws_instance" "jack-petclinic-lb" {
  ami                    = var.image
  instance_type          = var.inst_type
  availability_zone      = "eu-west-1b"
  key_name               = var.ssh_key
  subnet_id              = aws_subnet.jack-subnet-public-2.id
  vpc_security_group_ids = [aws_security_group.jack-sg-allow-web.id]

  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }

}

resource "aws_instance" "jack-petclinic-lb" {
  ami                    = var.image
  instance_type          = var.inst_type
  availability_zone      = "eu-west-1b"
  key_name               = var.ssh_key
  subnet_id              = aws_subnet.jack-subnet-public-2.id
  vpc_security_group_ids = [aws_security_group.jack-sg-allow-web.id]

  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }

}

