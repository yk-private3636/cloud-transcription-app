module "s3_bucket" {
  source = "../../modules/s3_bucket"

  name          = local.name
  environment   = var.env
  force_destroy = true
}