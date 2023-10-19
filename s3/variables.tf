variable "region" {
  type    = string
  default = "eu-west-1"
}
variable "bucket_name" {
  type    = string
  default = "<bucketname>"
}
variable "acl_value" {
  type    = string
  default = "private"
}

variable "mytags" {
  type = map
  default = {
    Name    = "<tagname>"
    Project = "<project_name>"
  }
}