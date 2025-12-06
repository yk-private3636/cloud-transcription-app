resource "aws_lambda_permission" "main" {
    action = var.action
    function_name = var.function_name
    principal = var.principal
    source_arn = var.source_arn
    source_account = var.source_account
}