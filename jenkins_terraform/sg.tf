# Create security group for Webserver

resource "aws_security_group" "jack-sg-allow-web" {
  name        = "allow_web_traffic"
  description = "Allow Web traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 
   ingress {
    description      = "Jenkins/PetClinic from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

# Create Security group for RDS

resource "aws_security_group" "jack-private-db" {
  vpc_id      = var.vpc_id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    description      = "DB from public subnet"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    #cidr_blocks      = ["100.20.48.0/20"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    #cidr_blocks      = ["100.20.48.0/20", "192.168.21.183", "77.108.144.130/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    #cidr_blocks      = ["100.20.48.0/20"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Jenkins/PetClinic from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}