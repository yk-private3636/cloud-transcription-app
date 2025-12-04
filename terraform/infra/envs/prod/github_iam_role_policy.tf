module "github_iam_role_policy" {
  source = "../../modules/iam_role_policy"

  name    = local.github_iam_role_policy_name
  role_id = module.github_actions_oidc_role.id
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:DescribeRepositories",
          "ecr:CreateRepository",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
        ]
        Resource = [
          module.ecr_repository.arn,
          "${module.ecr_repository.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:CreateBucket",
          "s3:PutObject",
          "s3:PutBucketNotification",
          "s3:PutBucketPublicAccessBlock"
        ]
        Resource = [
          module.s3_bucket_transcribe_input.arn,
          "${module.s3_bucket_transcribe_input.arn}/*",
          module.s3_bucket_transcribe_output.arn,
          "${module.s3_bucket_transcribe_output.arn}/*",
          var.s3_tfstate_arn,
          "${var.s3_tfstate_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "states:CreateStateMachine",
          "states:UpdateStateMachine",
        ]
        Resource = [module.sfn_state_machine.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "events:PutRule",
          "events:PutTargets",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "scheduler:CreateSchedule",
          "scheduler:CreateScheduleGroup",
          "scheduler:UpdateSchedule",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:AddPermission",
        ]
        Resource = [
          module.s3_daily_dir_function.arn,
          module.gen_nano_timestamp_function.arn,
          module.transcription_job_reader_function.arn,
          module.transcription_result_reader_function.arn,
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ses:CreateTemplate",
          "ses:UpdateTemplate",
        ]
        Resource = "*"
      }
    ]
  })
}