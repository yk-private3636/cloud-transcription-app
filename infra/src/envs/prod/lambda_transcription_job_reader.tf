module "transcription_job_reader_function" {
  source = "../../modules/lambda_function"

  name          = local.lambda_function_transcription_job_reader_name
  role_arn      = module.lambda_transcription_job_reader_iam_role.arn
  image_uri     = "${module.ecr.repository_url}:${var.transcription_job_reader_image_tag}"
  memory_size   = 128
  timeout       = 180
  architectures = ["x86_64"]
  environment = {
    variables = {
      APP_ENV = var.env
    }
  }
}