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

variable "email_from_address" {
  type      = string
  sensitive = true
}

variable "email_to_address" {
  type      = list(string)
  sensitive = true
}

variable "account_id" {
  type      = string
  sensitive = true
}

variable "assume_role_arn" {
  type      = string
  sensitive = true
}

variable "terraform_iam_user_name" {
  type      = string
  sensitive = true
}

variable "s3_daily_dir_image_tag" {
  type    = string
  default = "latest"
}

variable "gen_nano_timestamp_image_tag" {
  type    = string
  default = "latest"
}

variable "transcription_result_reader_image_tag" {
  type    = string
  default = "latest"
}

variable "transcription_job_reader_image_tag" {
  type    = string
  default = "latest"
}

variable "transcription_lang" {
  type    = string
  default = "ja-JP"
}

variable "bedrock_model_id" {
  type = string
}

variable "github_owner" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "s3_tfstate_arn" {
  type = string
}