// modules/s3/outputs.tf
output "bucket_arn" {
  value = aws_s3_bucket.spelling_bucket.arn
}