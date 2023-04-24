resource "random_string" "this" {
  length  = 6
  lower   = true
  numeric = true
  upper   = false
  special = false
}


resource "aws_s3_bucket" "mtc_bucket" {
  force_destroy = true
  bucket        = "mtcbucket${random_string.this.result}"

  tags = {
    Name        = "mtcbucket${random_string.this.result}"
    Environment = "Dev"
  }
}