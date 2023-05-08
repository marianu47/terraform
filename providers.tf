terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.66.1"
    }
  }
}

provider "aws" {
    region = "eu-west-3"
    access_key = var.aws_cred.ak
    secret_key = var.aws_cred.sk
}