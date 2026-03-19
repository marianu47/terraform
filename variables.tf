variable "aws_cred" {
  type = object({
    ak = string
    sk = string
  })
  default   = null
  nullable  = true
  sensitive = true
}

variable "ak" {
  type      = string
  default   = null
  nullable  = true
  sensitive = true
}

variable "sk" {
  type      = string
  default   = null
  nullable  = true
  sensitive = true
}

variable "region" {
  type        = string
  default     = "eu-west-3"
  description = "AWS region used by the provider."
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the main VPC."
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for the private subnet in the main VPC."
}

