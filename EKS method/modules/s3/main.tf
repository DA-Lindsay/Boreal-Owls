// modules/s3/main.tf
resource "aws_s3_bucket" "spelling_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "spelling_versioning" {
  bucket = aws_s3_bucket.spelling_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
