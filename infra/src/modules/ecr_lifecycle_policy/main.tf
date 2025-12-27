resource "aws_ecr_lifecycle_policy" "main" {
  repository = var.repository_name
  policy     = var.lifecycle_policy_json
}