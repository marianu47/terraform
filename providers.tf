locals {
  aws_access_key = var.aws_cred != null ? var.aws_cred.ak : var.ak
  aws_secret_key = var.aws_cred != null ? var.aws_cred.sk : var.sk
}

terraform {
  required_version = ">= 1.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = local.aws_access_key
  secret_key = local.aws_secret_key
}
