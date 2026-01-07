module "s3_bucket_ownership_controls_transcribe_input" {
  source    = "../../modules/s3_bucket_ownership_controls"
  bucket_id = module.s3_bucket_transcribe_input.id
}

module "s3_bucket_ownership_controls_transcribe_output" {
  source    = "../../modules/s3_bucket_ownership_controls"
  bucket_id = module.s3_bucket_transcribe_output.id
}