resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = var.bucket_id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}