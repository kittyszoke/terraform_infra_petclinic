variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "ssh_key" {
  type    = string
  default = "<your_key>.pem"
}


#Jenkins Control
variable "jenkins_control" {
  type    = string
  default = "ami-id"
}

#Jenkins Target
variable "jenkins_target" {
  type    = string
  default = "ami-id"
}

variable "vpc_id" {
  type = string
  default = "vpc-id"
  
}

variable "az-1" {
  type = string
  default = "eu-west-1a"
}

variable "az-2" {
  type = string
  default = "eu-west-1b"
}

variable "inst_type" {
  type    = string
  default = "t2.medium"
}

variable "igw" {
    type = string
    default = "igw-id"
  
}