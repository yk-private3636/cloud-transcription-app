provider "aws" {
  region = var.aws_region[0]
  assume_role {
    role_arn = var.executor_role_arn
  }
}