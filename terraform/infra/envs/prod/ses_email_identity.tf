module "ses_email_identity" {
  source = "../../modules/ses_email_identity"

  email_address = var.email_from_address
}