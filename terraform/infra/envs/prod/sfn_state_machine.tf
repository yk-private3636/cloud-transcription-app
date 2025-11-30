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
        Assign = {
          nanoTimestamp   = "{% $states.result.nanoTimestamp %}"
          eventBucketName = "{% $states.input.detail.bucket.name %}"
          eventBucketKey  = "{% $states.input.detail.object.key %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 3
          BackoffRate     = 1
        }]
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Output = {
            cause = "{% $states.errorOutput.Cause %}"
          }
          Next = "FailureSendMail"
        }]
        Next = "TranscriptionJob"
      },
      TranscriptionJob = {
        Type     = "Task"
        Resource = "arn:aws:states:::aws-sdk:transcribe:startTranscriptionJob"
        Arguments = {
          TranscriptionJobName = "{% '${local.transcription_job_name}' & '_' & $nanoTimestamp %}"
          Media = {
            MediaFileUri = "{% 's3://' & $eventBucketName & '/' & $eventBucketKey %}"
          }
          LanguageCode     = var.transcription_lang
          OutputBucketName = module.s3_bucket_transcribe_output.bucket
          OutputKey        = "{% $eventBucketKey & '/' & $nanoTimestamp & '/' & '${local.transcription_output_file}' %}"
        }
        Assign = {
          transcriptionJobName = "{% '${local.transcription_job_name}' & '_' & $nanoTimestamp %}"
          outputBucketName     = module.s3_bucket_transcribe_output.bucket
          outputBucketKey      = "{% $eventBucketKey & '/' & $nanoTimestamp & '/' & '${local.transcription_output_file}' %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 3
          BackoffRate     = 1
        }]
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Output = {
            cause = "{% $states.errorOutput.Cause %}"
          }
          Next = "FailureSendMail"
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
          jobName = "{% $transcriptionJobName %}"
        }
        Output = {
          transcriptionJobStatus = "{% $states.result.jobStatus %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 5
          MaxDelaySeconds = 5
          BackoffRate     = 3
        }]
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Output = {
            cause = "{% $states.errorOutput.Cause %}"
          }
          Next = "FailureSendMail"
        }]
        Next = "CheckTranscriptionJobStatus"
      }
      CheckTranscriptionJobStatus = {
        Type = "Choice"
        Choices = [{
          Condition = "{% $states.input.transcriptionJobStatus = 'COMPLETED' %}"
          Next      = "TranscriptionResultReader"
          }, {
          Condition = "{% $states.input.transcriptionJobStatus = 'FAILED' %}"
          Next      = "TranscriptionJobFailureStatus"
          }, {
          Condition = "{% $states.input.transcriptionJobStatus != 'COMPLETED' and $states.input.transcriptionJobStatus != 'FAILED' %}"
          Next      = "WaitTranscriptionJobReader"
          }
        ]
      }
      TranscriptionResultReader = {
        Type     = "Task"
        Resource = module.transcription_result_reader_function.arn
        Arguments = {
          bucket = "{% $outputBucketName %}"
          key    = "{% $outputBucketKey %}"
        }
        Output = {
          transcriptionText = "{% $states.result.transcript %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 5
          MaxDelaySeconds = 5
          BackoffRate     = 3
        }]
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Output = {
            cause = "{% $states.errorOutput.Cause %}"
          }
          Next = "FailureSendMail"
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
          bedrockContent = "{% $states.result.Output.Message.Content[0].Text %}"
        }
        Retry = [{
          ErrorEquals     = ["States.ALL"]
          IntervalSeconds = 3
          MaxAttempts     = 5
          MaxDelaySeconds = 5
          BackoffRate     = 3
        }]
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Output = {
            cause = "{% $states.errorOutput.Cause %}"
          }
          Next = "FailureSendMail"
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
              TemplateData = "{% '{' & '\"fileName\":' & '\"' & $eventBucketKey & '\"' & '}' %}"
              Attachments = [{
                FileName    = "{% 'summary_' & $split($eventBucketKey, \"/\")[$count($split($eventBucketKey, \"/\")) - 1] & '.txt' %}"
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
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Output = {
            cause = "{% $states.errorOutput.Cause %}"
          }
          Next = "FailureSendMail"
        }]
        End = true
      }
      TranscriptionJobFailureStatus = {
        Type = "Pass"
        Output = {
          cause = "{% 'Transcription job failed. Please check the input media file.' %}"
        }
        Next = "FailureSendMail"
      }
      FailureSendMail = {
        Type     = "Task"
        Resource = "arn:aws:states:::aws-sdk:sesv2:sendEmail"
        Arguments = {
          FromEmailAddress = var.email_address
          Destination = {
            ToAddresses = [var.email_address]
          }
          Content = {
            Template = {
              TemplateArn  = module.ses_fail_template.arn
              TemplateName = module.ses_fail_template.name
              TemplateData = "{% '{' & '\"fileName\":' & '\"' & $eventBucketKey & '\",' & '\"errorMessage\":' & '\"' & $states.input.cause & '\",' & '\"executionId\":' & '\"' & $states.context.Execution.Id & '\"' & '}' %}"
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