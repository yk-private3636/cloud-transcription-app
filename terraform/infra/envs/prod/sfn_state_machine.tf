module "sfn_state_machine" {
  source = "../../modules/sfn_state_machine"

  name     = local.sfn_state_machine_name
  role_arn = module.sfn_iam_role.arn
  asl_definition = jsonencode({
    QueryLanguage = "JSONata"
    StartAt       = "GenNanoTimestamp"
    States = {
      GenNanoTimestamp = {
        Type     = "Task"
        Resource = module.gen_nano_timestamp_function.arn
        Output = {
          detail         = "{% $states.input.detail %}",
          nano_timestamp = "{% $states.result.nano_timestamp %}"
        }
        Next = "TranscriptionJob"
      },
      TranscriptionJob = {
        Type     = "Task"
        Resource = "arn:aws:states:::aws-sdk:transcribe:startTranscriptionJob"
        Arguments = {
          TranscriptionJobName = "{% '${local.transcription_job_name}' & '_' & $states.input.nano_timestamp %}"
          Media = {
            MediaFileUri = "{% 's3://' & $states.input.detail.bucket.name & '/' & $states.input.detail.object.key %}"
          }
          LanguageCode     = var.transcription_lang
          OutputBucketName = module.s3_bucket_transcribe_output.bucket
          OutputKey        = "{% $states.input.detail.object.key & '/' & $states.input.nano_timestamp & '/' & '${local.transcription_output_file}' %}"
        }
        Output = {
          outputBucketName = module.s3_bucket_transcribe_output.bucket
          outputKey        = "{% $states.input.detail.object.key & '/' & $states.input.nano_timestamp & '/' & '${local.transcription_output_file}' %}"
        }
        Next = "TranscriptionResultReader"
      }
      TranscriptionResultReader = {
        Type     = "Task"
        Resource = module.transcription_result_reader_function.arn
        Arguments = {
          bucket = "{% $states.input.outputBucketName %}"
          key    = "{% $states.input.outputKey %}"
        }
        End = true
      }
    }
  })
}