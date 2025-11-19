module "ecr_repository" {
  source = "../../modules/ecr_repository"

  name                 = local.ecr_repository_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}