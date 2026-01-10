resource "aws_s3_bucket_notification" "main" {
  bucket      = var.bucket_id
  eventbridge = var.eventbridge
}