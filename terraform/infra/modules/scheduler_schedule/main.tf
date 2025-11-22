resource "aws_scheduler_schedule" "main" {
  name = var.name
  target {
    arn = var.target.arn
    role_arn = var.target.role_arn
  }

  flexible_time_window {
    mode                      = var.flexible_time_window.mode
    maximum_window_in_minutes = var.flexible_time_window.maximum_window_in_minutes
  }

  schedule_expression = var.schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone
}