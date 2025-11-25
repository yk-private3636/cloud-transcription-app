module "s3_content_function" {
  source = "../../modules/lambda_function"

  name          = local.lambda_function_s3_content_name
  role_arn      = module.lambda_s3_content_iam_role.arn
  image_uri     = "${module.ecr_repository.repository_url}:${var.s3_content_image_tag}"
  memory_size   = 128
  timeout       = 180
  architectures = ["x86_64"]
  environment = {
    variables = {
      APP_ENV = var.env
    }
  }
}