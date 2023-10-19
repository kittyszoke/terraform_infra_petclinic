# DB / Private Subnet settings

# Associate subnet with route table
resource "aws_route_table_association" "jack-subnet-db-association" {
  subnet_id      = aws_subnet.jack-subnet-private.id
  route_table_id = aws_route_table.jack-dev-routetable.id
}


# Create NACL 

resource "aws_network_acl" "jack-nacl-private" {
  vpc_id = var.vpc_id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    #cidr_block = "100.20.32.0/20"
    cidr_blocks = []
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

resource "aws_db_subnet_group" "jack-mariadb-subnet-group" {
  name       = "petclinic-mariadb-subnetgroup"
  subnet_ids = [aws_subnet.jack-subnet-private.id, aws_subnet.jack-subnet-private-2.id]

  tags = {
    Name = "<tagname>"
  }
}


# Create RDS

resource "aws_db_instance" "jack-petclinic-rds" {
  allocated_storage    = 10
  max_allocated_storage = 40
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "petclinic" #This has to match with the name use id Ansible, otherwise it won't connect
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.jack-mariadb-subnet-group.id
  multi_az             = false
  final_snapshot_identifier = "Ignore"
  vpc_security_group_ids = [aws_security_group.jack-private-db.id]
  snapshot_identifier = var.db_snapshot_identifier # Using previously created DB snapshot 

   tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }
}

# Insert data to DB

#resource "null_resource" "jack-petclinic-rds" {
#  depends_on = [aws_db_instance.jack-petclinic-rds] #wait for the db to be ready
#  provisioner "local-exec" {
#  command = <<EOT
#    "git clone https://github.com/spring-projects/spring-petclinic/ ~/petclinic || (cd ~/petclinic && git pull)" 
#    "mysql -h ${aws_db_instance.jack-petclinic-rds.address} -P 3306 -u ${var.db_username} -p${var.db_password} -e 'create database if not exist petclinic'"
#    "mysql -h ${aws_db_instance.jack-petclinic-rds.address} -P 3306 -u ${var.db_username} -p${var.db_password} petclinic < ~/petclinic/src/main/resources/db/mysql/data.sql"
#    "mysql -h ${aws_db_instance.jack-petclinic-rds.address} -P 3306 -u ${var.db_username} -p${var.db_password} petclinic < ~/petclinic/src/main/resources/db/mysql/schema.sql"
#  EOT 
#  }
#}

