module "lambda_s3_daily_dir_permission" {
  source = "../../modules/lambda_permission"

  action         = "lambda:InvokeFunction"
  function_name  = module.s3_daily_dir_function.name
  principal      = "scheduler.amazonaws.com"
  source_account = var.account_id
  source_arn     = module.scheduler_s3_daily_dir.arn
}