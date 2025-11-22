module "scheduler_s3_daily_dir_iam_role_policy" {
  source = "../../modules/iam_role_policy"

  name    = local.scheduler_s3_daily_dir_policy_name
  role_id = module.scheduler_s3_daily_dir_iam_role.id
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = module.s3_daily_dir_function.arn
      }
    ]
  })
}