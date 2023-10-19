terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "<bucketname>"
    key    = "tf-workspace/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.region
}