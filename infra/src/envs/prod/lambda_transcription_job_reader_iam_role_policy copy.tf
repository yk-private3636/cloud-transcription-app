module "lambda_transcription_job_reader_iam_role_policy" {
  source = "../../modules/iam_role_policy"

  name    = local.lambda_function_transcription_job_reader_policy_name
  role_id = module.lambda_transcription_job_reader_iam_role.id
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "transcribe:GetTranscriptionJob",
        ]
        Resource = "*"
      }
    ]
  })
}