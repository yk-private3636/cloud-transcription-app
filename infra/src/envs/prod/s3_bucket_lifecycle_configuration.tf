module "s3_bucket_transcribe_input_lifecycle_configuration" {
  source = "../../modules/s3_bucket_lifecycle_configuration"

  bucket_id = module.s3_bucket_transcribe_input.id

  lifecycle_rules = [
    {
      id     = local.s3_bucket_transcribe_input_lifecycle_rule_id
      status = "Enabled"
      expiration = {
        days = 7
      }
    }
  ]
}

module "s3_bucket_transcribe_output_lifecycle_configuration" {
  source = "../../modules/s3_bucket_lifecycle_configuration"

  bucket_id = module.s3_bucket_transcribe_output.id

  lifecycle_rules = [
    {
      id     = local.s3_bucket_transcribe_output_lifecycle_rule_id
      status = "Enabled"
      expiration = {
        days = 7
      }
    }
  ]
}