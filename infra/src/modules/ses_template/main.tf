resource "aws_ses_template" "main" {
    name = var.name
    subject = var.subject
    text = var.text
}