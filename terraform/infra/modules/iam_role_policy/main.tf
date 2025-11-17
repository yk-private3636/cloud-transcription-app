resource "aws_iam_role_policy" "main" {
    name = var.name
    role = var.role_id
    policy = var.policy_document
}