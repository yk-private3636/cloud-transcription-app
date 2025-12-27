resource "aws_ecr_repository" "main" {
    name                 = var.name
    image_tag_mutability = var.image_tag_mutability
    force_delete = var.force_delete
    
    tags = {
        Name = var.name
    }
}