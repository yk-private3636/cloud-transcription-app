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
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:CreateRepository",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchDeleteImage",
          "ecr:getLifecyclePolicy",
          "ecr:PutLifecyclePolicy",
        ]
        Resource = [
          module.ecr_repository.arn,
          "${module.ecr_repository.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:ListBucket",
          "s3:CreateBucket",
          "s3:PutBucketNotification",
          "s3:PutBucketPublicAccessBlock"
        ]
        Resource = [
          module.s3_bucket_transcribe_input.arn,
          "${module.s3_bucket_transcribe_input.arn}/*",
          module.s3_bucket_transcribe_output.arn,
          "${module.s3_bucket_transcribe_output.arn}/*",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Resource = [
          var.s3_tfstate_arn,
          "${var.s3_tfstate_arn}/*",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "states:DescribeStateMachine",
          "states:ListStateMachineVersions",
          "states:ListTagsForResource",
          "states:CreateStateMachine",
          "states:UpdateStateMachine",
        ]
        Resource = [
          module.sfn_state_machine.arn,
          "${module.sfn_state_machine.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "events:DescribeRule",
          "events:ListTagsForResource",
          "events:ListTargetsByRule",
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
          "scheduler:GetSchedule"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:GetPolicy",
          "lambda:GetLayerVersionPolicy",
          "lambda:GetFunction",
          "lambda:ListVersionsByFunction",
          "lambda:AddPermission",
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:RemovePermission",
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
          "ses:GetTemplate",
          "ses:GetIdentityVerificationAttributes",
          "ses:GetCustomVerificationEmailTemplate",
          "ses:CreateTemplate",
          "ses:UpdateTemplate",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:*",
        ]
        Resource = "*"
      }
    ]
  })
}