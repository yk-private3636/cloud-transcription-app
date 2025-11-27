module "s3_bucket_transcribe_input" {
  source = "../../modules/s3_bucket"

  name          = local.s3_bucket_transcribe_input_name
  environment   = var.env
  force_destroy = true
}

module "s3_bucket_transcribe_output" {
  source = "../../modules/s3_bucket"

  name          = local.s3_bucket_transcribe_output_name
  environment   = var.env
  force_destroy = true
}