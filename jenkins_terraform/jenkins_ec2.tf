resource "aws_instance" "jack-jenkins-server-Control" {
  ami                    = var.jenkins_control
  instance_type          = var.inst_type
  availability_zone      = "eu-west-1a"
  #key_name               = var.ssh_key
  subnet_id              = aws_subnet.jack-subnet-public.id
  vpc_security_group_ids = [aws_security_group.jack-sg-allow-web.id]

  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }

}

resource "aws_instance" "jack-jenkins-server-agent" {
  ami                    = var.jenkins_target
  instance_type          = var.inst_type
  availability_zone      = "eu-west-1a"
  #key_name               = var.ssh_key
  subnet_id              = aws_subnet.jack-subnet-public.id
  vpc_security_group_ids = [aws_security_group.jack-sg-allow-web.id]

  tags = {
    Name = "<tagname>"
    Project = "<project_name>"
  }

}