variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "az-1" {
  type = string
  default = "eu-west-1a"
}

variable "az-2" {
  type = string
  default = "eu-west-1b"
}

# Petclinic AMI
variable "image" {
  type    = string
  default = "ami-id"
}

variable "inst_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
  default = "vpc-id"
  
}

variable "ssh_key" {
  type    = string
  default = "<your_key>.pem"
}

variable "igw" {
    type = string
    default = "igw-id"
  
}

variable "db_username" {
  type = string
  default = "<username>"
}

variable "db_password" {
  type = string
  default = "<password>"
}

variable "db_snapshot_identifier" {
  type = string
  default = "<snapshot_id>"
}