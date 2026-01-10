resource "aws_sfn_state_machine" "main" {
  name       = var.name
  role_arn   = var.role_arn
  definition = var.asl_definition
}