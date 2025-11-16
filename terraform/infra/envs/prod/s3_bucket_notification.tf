module "s3_bucket_notification" {
  source = "../../modules/s3_bucket_notification"

  bucket_id   = module.s3_bucket.id
  eventbridge = true
}