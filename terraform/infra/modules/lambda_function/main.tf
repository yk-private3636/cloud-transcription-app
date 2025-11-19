resource "aws_lambda_function" "main" {
  function_name = var.name
  role          = var.role_arn
  package_type = "Image"
  image_uri     = var.image_uri
    memory_size = var.memory_size
    timeout     = var.timeout
    architectures = var.architectures

  tags = {
    Name = var.name
  }
}