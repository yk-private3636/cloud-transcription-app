variable "name" {
  type = string
}

variable "group_name" {
  type = string
}

variable "target" {
  type = object({
    arn      = string
    role_arn = string
  })
}

variable "flexible_time_window" {
  type = object({
    maximum_window_in_minutes = number
    mode                      = string
  })
}

variable "schedule_expression" {
  type = string
}

variable "schedule_expression_timezone" {
  type = string
}