resource "aws_cloudwatch_event_target" "main" {
    rule = var.rule_name
    target_id = var.target_id
    arn = var.target_arn
    role_arn = var.role_arn
}