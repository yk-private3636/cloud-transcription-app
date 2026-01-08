resource "aws_iam_role" "main" {
  name               = var.name
  assume_role_policy = var.assume_role_policy
}