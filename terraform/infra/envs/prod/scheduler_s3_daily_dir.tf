module "scheduler_s3_daily_dir" {
  source = "../../modules/scheduler_schedule"

  name = local.scheduler_s3_daily_dir_name
  flexible_time_window = {
    mode                      = "OFF"
    maximum_window_in_minutes = null
  }
  schedule_expression          = "cron(0 0 * * ? *)"
  schedule_expression_timezone = var.timezone
  target = {
    arn      = module.s3_daily_dir_function.arn
    role_arn = module.scheduler_s3_daily_dir_iam_role.arn
  }
}