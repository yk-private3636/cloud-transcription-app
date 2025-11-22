module "s3_daily_dir" {
  source = "../../modules/lambda_function"

  name          = local.lambda_function_s3_daily_dir_name
  role_arn      = module.iam_role_lambda_s3_daily_dir.arn
  image_uri     = "${module.ecr_repository.repository_url}:${var.s3_daily_dir_image_tag}"
  memory_size   = 128
  timeout       = 180
  architectures = ["x86_64"]
  environment = {
    variables = {
      APP_ENV      = var.env
      STORAGE_NAME = module.s3_bucket.bucket
    }
  }
}