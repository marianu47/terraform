data "aws_caller_identity" "current" {}

locals {
  s3_bucket_name = "terraform-demo-${data.aws_caller_identity.current.account_id}-${var.region}"
}

resource "aws_s3_bucket" "main" {
  bucket = local.s3_bucket_name

  tags = {
    Name = local.s3_bucket_name
  }
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket created by Terraform"
  value       = aws_s3_bucket.main.bucket
}
