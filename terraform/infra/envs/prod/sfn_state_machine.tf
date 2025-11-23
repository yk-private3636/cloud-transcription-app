module "sfn_state_machine" {
  source = "../../modules/sfn_state_machine"

  name     = local.sfn_state_machine_name
  role_arn = module.sfn_iam_role.arn
  asl_definition = jsonencode({
    QueryLanguage = "JSONata"
    StartAt       = "TranscriptionJob"
    States = {
      TranscriptionJob = {
        Type = "Task"
        Arguments = {
          TranscriptionJobName = local.transcription_job_name
          Media = {
            MediaFileUri = "{% 's3://' & $states.input.detail.bucket.name & '/' & $states.input.detail.object.key %}"
          }
          LanguageCode     = var.transcription_lang
          OutputBucketName = module.s3_bucket.bucket
        }
        Resource = "arn:aws:states:::aws-sdk:transcribe:startTranscriptionJob"
        End      = true
      }
    }
  })
}