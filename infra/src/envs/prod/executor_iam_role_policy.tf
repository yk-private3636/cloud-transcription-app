module "executor_role_policy" {
  source = "../../modules/iam_role_policy"

  name    = local.executor_role_policy_name
  role_id = module.executor_role.id
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
          "ecr:GetLifecyclePolicy",
          "ecr:PutLifecyclePolicy",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:PutImageTagMutability",
          "ecr:PutImageScanningConfiguration",
          "ecr:SetRepositoryPolicy",
          "ecr:GetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy",
        ]
        Resource = [
          "arn:aws:ecr:${var.aws_region[0]}:${var.account_id}:repository/${local.name}",
          "arn:aws:ecr:${var.aws_region[0]}:${var.account_id}:repository/${local.name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:ListBucket",
          "s3:CreateBucket",
          "s3:PutBucketNotification",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutLifecycleConfiguration",
          "s3:PutBucketTagging",
          "s3:PutObject",
          "s3:DeleteBucket",
          "s3:DeleteObject",
          "s3:PutBucketOwnershipControls",
          "s3:GetBucketOwnershipControls",
        ]
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_transcribe_input_name}",
          "arn:aws:s3:::${local.s3_bucket_transcribe_input_name}/*",
          "arn:aws:s3:::${local.s3_bucket_transcribe_output_name}",
          "arn:aws:s3:::${local.s3_bucket_transcribe_output_name}/*",
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
          "arn:aws:s3:::${var.project_name}-tfstate",
          "arn:aws:s3:::${var.project_name}-tfstate/*",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "states:DescribeStateMachine",
          "states:ListStateMachineVersions",
          "states:ListTagsForResource",
          "states:ValidateStateMachineDefinition",
          "states:CreateStateMachine",
          "states:UpdateStateMachine",
          "states:TagResource",
          "states:UntagResource",
          "states:DeleteStateMachine",
        ]
        Resource = [
          "arn:aws:states:${var.aws_region[0]}:${var.account_id}:stateMachine:${local.sfn_state_machine_name}",
          "arn:aws:states:${var.aws_region[0]}:${var.account_id}:stateMachine:${local.sfn_state_machine_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "states:ValidateStateMachineDefinition",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "events:DescribeRule",
          "events:ListTagsForResource",
          "events:ListTargetsByRule",
          "events:PutRule",
          "events:PutTargets",
          "events:TagResource",
          "events:UntagResource",
          "events:RemoveTargets",
          "events:DeleteRule",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "scheduler:CreateSchedule",
          "scheduler:CreateScheduleGroup",
          "scheduler:UpdateSchedule",
          "scheduler:GetSchedule",
          "scheduler:GetScheduleGroup",
          "scheduler:DeleteSchedule",
          "scheduler:DeleteScheduleGroup",
          "scheduler:ListTagsForResource",
          "scheduler:TagResource",
          "scheduler:UntagResource",
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
          "lambda:TagResource",
          "lambda:UntagResource",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:RemovePermission",
          "lambda:DeleteFunction"
        ]
        Resource = [
          "arn:aws:lambda:${var.aws_region[0]}:${var.account_id}:function:${local.lambda_function_s3_daily_dir_name}",
          "arn:aws:lambda:${var.aws_region[0]}:${var.account_id}:function:${local.lambda_function_gen_nano_timestamp_name}",
          "arn:aws:lambda:${var.aws_region[0]}:${var.account_id}:function:${local.lambda_function_transcription_job_reader_name}",
          "arn:aws:lambda:${var.aws_region[0]}:${var.account_id}:function:${local.lambda_function_transcription_result_reader_name}",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ses:GetTemplate",
          "ses:GetIdentityVerificationAttributes",
          "ses:GetCustomVerificationEmailTemplate",
          "ses:VerifyEmailIdentity",
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
        Resource = [
          "arn:aws:iam::${var.account_id}:role/${local.name}-*",
          "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com",
        ]
      }
    ]
  })
}