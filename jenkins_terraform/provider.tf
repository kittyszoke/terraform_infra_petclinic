terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  #backend "s3" {
  #  bucket = "ch10jackpetclinicbucket"
  #  key    = "tf-workspace/terraform.tfstate"
  #  region = "eu-west-1"
  #}
}

provider "aws" {
  region = var.region
}