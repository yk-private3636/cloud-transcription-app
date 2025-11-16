resource "aws_cloudwatch_event_rule" "main" {
    name = var.name
    description = var.description
    event_pattern = var.event_pattern
}