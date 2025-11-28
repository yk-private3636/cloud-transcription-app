module "sfn_state_machine" {
  source = "../../modules/sfn_state_machine"

  name     = local.sfn_state_machine_name
  role_arn = module.sfn_iam_role.arn
  asl_definition = jsonencode({
    QueryLanguage  = "JSONata"
    StartAt        = "GenNanoTimestamp"
    TimeoutSeconds = 1200
    States = {
      GenNanoTimestamp = {
        Type     = "Task"
        Resource = module.gen_nano_timestamp_function.arn
        Output = {
          detail        = "{% $states.input.detail %}",
          nanoTimestamp = "{% $states.result.nanoTimestamp %}"
        }
        Next = "TranscriptionJob"
      },
      TranscriptionJob = {
        Type     = "Task"
        Resource = "arn:aws:states:::aws-sdk:transcribe:startTranscriptionJob"
        Arguments = {
          TranscriptionJobName = "{% '${local.transcription_job_name}' & '_' & $states.input.nanoTimestamp %}"
          Media = {
            MediaFileUri = "{% 's3://' & $states.input.detail.bucket.name & '/' & $states.input.detail.object.key %}"
          }
          LanguageCode     = var.transcription_lang
          OutputBucketName = module.s3_bucket_transcribe_output.bucket
          OutputKey        = "{% $states.input.detail.object.key & '/' & $states.input.nanoTimestamp & '/' & '${local.transcription_output_file}' %}"
        }
        Output = {
          outputBucketName = module.s3_bucket_transcribe_output.bucket
          outputKey        = "{% $states.input.detail.object.key & '/' & $states.input.nanoTimestamp & '/' & '${local.transcription_output_file}' %}"
          nanoTimestamp    = "{% $states.input.nanoTimestamp %}"
        }
        Next = "TranscriptionJobReader"
      }
      WaitTranscriptionJobReader = {
        Type    = "Wait"
        Seconds = 10
        Next    = "TranscriptionJobReader"
      }
      TranscriptionJobReader = {
        Type     = "Task"
        Resource = module.transcription_job_reader_function.arn
        Arguments = {
          jobName = "{% '${local.transcription_job_name}' & '_' & $states.input.nanoTimestamp %}"
        }
        Output = {
          jobStatus        = "{% $states.result.jobStatus %}"
          nanoTimestamp    = "{% $states.input.nanoTimestamp %}"
          outputBucketName = "{% $states.input.outputBucketName %}"
          outputKey        = "{% $states.input.outputKey %}"
        }
        Next = "CheckTranscriptionStatus"
      }
      CheckTranscriptionStatus = {
        Type = "Choice"
        Choices = [{
          Condition = "{% $states.input.jobStatus = 'COMPLETED' %}"
          Next      = "TranscriptionResultReader"
          }, {
          Condition = "{% $states.input.jobStatus != 'FAILED' %}"
          Next      = "WaitTranscriptionJobReader"
          }
        ]
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