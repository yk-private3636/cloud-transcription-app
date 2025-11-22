variable "env" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  type    = string
  default = "cloud-transcription-app"

  validation {
    condition     = var.project_name == "cloud-transcription-app"
    error_message = "The project_name variable must be set to 'cloud-transcription-app'. Overriding this value is not allowed."
  }
}

variable "aws_region" {
  type    = list(string)
  default = ["ap-northeast-1", "ap-northeast-3"]
}

variable "aws_az" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "timezone" {
  type = string
}

variable "email_address" {
  type      = string
  sensitive = true
}

variable "account_id" {
  type      = string
  sensitive = true
}

variable "s3_daily_dir_image_tag" {
  type    = string
  default = "latest"
}