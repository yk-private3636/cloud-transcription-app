resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = var.bucket_id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status
      expiration {
        days = rule.value.expiration.days
      }
    }
  }
}