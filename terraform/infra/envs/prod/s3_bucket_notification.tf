module "s3_bucket_notification_transcribe_input" {
  source = "../../modules/s3_bucket_notification"

  bucket_id   = module.s3_bucket_transcribe_input.id
  eventbridge = true
}