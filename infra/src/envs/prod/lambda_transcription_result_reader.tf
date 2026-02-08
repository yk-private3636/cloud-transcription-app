module "transcription_result_reader_function" {
  source = "../../modules/lambda_function"

  name          = local.lambda_function_transcription_result_reader_name
  role_arn      = module.lambda_transcription_result_reader_iam_role.arn
  image_uri     = "${module.ecr.repository_url}:${var.transcription_result_reader_image_tag}"
  memory_size   = 256
  timeout       = 900
  architectures = ["x86_64"]
  environment = {
    variables = {
      APP_ENV = var.env
    }
  }
}