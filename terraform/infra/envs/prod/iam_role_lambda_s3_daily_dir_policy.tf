module "iam_role_lambda_s3_daily_dir_policy" {
  source = "../../modules/iam_role_policy"

  name    = local.lambda_function_policy_name
  role_id = module.iam_role_lambda_s3_daily_dir.id
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
        ]
        Resource = "${module.s3_bucket.arn}/*"
      }
    ]
  })
}