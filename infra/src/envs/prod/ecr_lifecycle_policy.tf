module "ecr_lifecycle_policy" {
  source = "../../modules/ecr_lifecycle_policy"

  repository_name = module.ecr_repository.name
  lifecycle_policy_json = jsonencode({
    "rules" = [
      {
        "rulePriority" = 1
        "description"  = "Expire untagged images older than 1 day"
        "selection" = {
          "tagStatus"   = "untagged"
          "countType"   = "sinceImagePushed"
          "countUnit"   = "days"
          "countNumber" = 1
        }
        "action" = {
          "type" = "expire"
        }
      },
      {
        "rulePriority" = 2
        "description"  = "Expire tagged images 90 days after transitioning to archive storage"
        "selection" = {
          "tagStatus"      = "tagged"
          "tagPatternList" = ["*"]
          "storageClass"   = "archive"
          "countType"      = "sinceImageTransitioned"
          "countUnit"      = "days"
          "countNumber"    = 90
        }
        "action" = {
          "type" = "expire"
        }
      },
      {
        "rulePriority" = 3
        "description"  = "Expire untagged images 90 days after transitioning to archive storage"
        "selection" = {
          "tagStatus"    = "untagged"
          "storageClass" = "archive"
          "countType"    = "sinceImageTransitioned"
          "countUnit"    = "days"
          "countNumber"  = 90
        }
        "action" = {
          "type" = "expire"
        }
      }
    ]
  })
}