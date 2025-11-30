module "sfn_state_machine" {
  source = "../../modules/sfn_state_machine"

  name     = local.sfn_state_machine_name
  role_arn = module.sfn_iam_role.arn
  asl_definition = jsonencode({
    QueryLanguage  = "JSONata"
    StartAt        = "GenNanoTimestamp"
    TimeoutSeconds = 900
    States = {
      GenNanoTimestamp = {
        Type     = "Task"
        Resource = module.gen_nano_timestamp_function.arn
        Output = {
          detail        = "{% $states.input.detail %}",
          nanoTimestamp = "{% $states.result.nanoTimestamp %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 3
          BackoffRate     = 1
        }]
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
          inputKey         = "{% $states.input.detail.object.key %}"
          outputBucketName = module.s3_bucket_transcribe_output.bucket
          outputKey        = "{% $states.input.detail.object.key & '/' & $states.input.nanoTimestamp & '/' & '${local.transcription_output_file}' %}"
          nanoTimestamp    = "{% $states.input.nanoTimestamp %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 3
          BackoffRate     = 1
        }]
        Next = "TranscriptionJobReader"
      }
      WaitTranscriptionJobReader = {
        Type    = "Wait"
        Seconds = 20
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
          inputKey         = "{% $states.input.inputKey %}"
          outputBucketName = "{% $states.input.outputBucketName %}"
          outputKey        = "{% $states.input.outputKey %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 5
          MaxDelaySeconds = 5
          BackoffRate     = 3
        }]
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
        Output = {
          key               = "{% $states.input.inputKey %}"
          transcriptionText = "{% $states.result.transcript %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 5
          MaxDelaySeconds = 5
          BackoffRate     = 3
        }]
        Next = "BedrockConverse"
      }
      BedrockConverse = {
        Type     = "Task"
        Resource = "arn:aws:states:::aws-sdk:bedrockruntime:converse"
        Arguments = {
          ModelId = var.bedrock_model_id
          Messages = [
            {
              Role = "user",
              Content = [
                {
                  Text = "{% 'STARTという文字列から音声を文字おこしした結果なんだけど、要点を箇条書きでまとめてほしいのとそのまとめた内容だけを出力してほしい。(了解しましたとかの文章は不要です)' & ' START ' & $states.input.transcriptionText %}"
                }
              ]
            }
          ]
        }
        Output = {
          key            = "{% $states.input.key %}"
          bedrockContent = "{% $states.result.Output.Message.Content[0].Text %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 5
          MaxDelaySeconds = 5
          BackoffRate     = 3
        }]
        Next = "SuccessSendMail"
      }
      SuccessSendMail = {
        Type     = "Task"
        Resource = "arn:aws:states:::aws-sdk:sesv2:sendEmail"
        Arguments = {
          FromEmailAddress = var.email_address
          Destination = {
            ToAddresses = [var.email_address]
          }
          Content = {
            Template = {
              TemplateArn  = module.ses_success_template.arn
              TemplateName = module.ses_success_template.name
              TemplateData = "{% '{' & '\"fileName\":' & '\"' & $states.input.key & '\"' & '}' %}"
              Attachments = [{
                FileName    = "{% 'summary_' & $split($states.input.key, \"/\")[$count($split($states.input.key, \"/\")) - 1] & '.txt' %}"
                ContentType = "text/plain"
                RawContent  = "{% $states.input.bedrockContent %}"
              }]
            }
          }
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 5
          MaxAttempts     = 2
          BackoffRate     = 1
        }]
        End = true
      }
    }
  })
}