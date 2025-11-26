module "s3_bucket_public_access_block_transcribe_input" {
  source = "../../modules/s3_bucket_public_access_block"

  bucket_id               = module.s3_bucket_transcribe_input.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "s3_bucket_public_access_block_transcribe_output" {
  source = "../../modules/s3_bucket_public_access_block"

  bucket_id               = module.s3_bucket_transcribe_output.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "s3_bucket_public_access_block_bedrock_output" {
  source = "../../modules/s3_bucket_public_access_block"

  bucket_id               = module.s3_bucket_bedrock_output.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}