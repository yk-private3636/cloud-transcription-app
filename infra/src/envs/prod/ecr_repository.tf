module "ecr_repository" {
  source = "../../modules/ecr_repository"

  name                 = local.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
  force_delete         = false
}