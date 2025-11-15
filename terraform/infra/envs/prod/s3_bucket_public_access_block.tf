module "s3_bucket_public_access_block" {
  source = "../../modules/s3_bucket_public_access_block"

  bucket_id               = module.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}