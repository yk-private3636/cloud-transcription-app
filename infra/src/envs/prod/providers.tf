provider "aws" {
  region = var.aws_region[0]
  assume_role {
    role_arn = var.assume_role_arn
  }
}