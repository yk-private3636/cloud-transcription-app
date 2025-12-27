resource "aws_s3_bucket" "main" {
    bucket = var.name
    force_destroy = var.force_destroy
    
    tags = {
        Name        = var.name
        Environment = var.environment
    }
}