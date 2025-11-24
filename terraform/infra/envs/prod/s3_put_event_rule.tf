module "s3_put_event_rule" {
  source = "../../modules/cloudwatch_event_rule"

  name        = local.s3_put_event_name
  description = "Event rule for S3 put events in ${var.env} environment"
  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [module.s3_bucket_transcribe_input.bucket]
      },
      object = {
        key = [{
          "wildcard" = "*/*.*"
        }],
        size = [{
          "numeric" = [">", 0]
        }]
      }
    }
  })
}