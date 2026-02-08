module "gen_nano_timestamp_function" {
  source = "../../modules/lambda_function"

  name          = local.lambda_function_gen_nano_timestamp_name
  role_arn      = module.lambda_gen_nano_timestamp_iam_role.arn
  image_uri     = "${module.ecr.repository_url}:${var.gen_nano_timestamp_image_tag}"
  memory_size   = 128
  timeout       = 180
  architectures = ["x86_64"]
  environment = {
    variables = {
      APP_ENV      = var.env
      APP_TIMEZONE = var.timezone
    }
  }
}