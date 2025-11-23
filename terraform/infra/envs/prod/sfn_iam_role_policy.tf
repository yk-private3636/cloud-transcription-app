module "sfn_iam_role_policy" {
  source = "../../modules/iam_role_policy"

  name    = local.sfn_policy_name
  role_id = module.sfn_iam_role.id
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "transcribe:StartTranscriptionJob"
        ]
        Resource = "*"
        }, {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${module.s3_bucket.arn}/*"
        }, {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = "${module.gen_nano_timestamp_function.arn}"
      }
    ]
  })
}