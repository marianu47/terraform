variable "aws_cred" {
  type = object({
    ak = string
    sk = string
  })
  sensitive = true
}

