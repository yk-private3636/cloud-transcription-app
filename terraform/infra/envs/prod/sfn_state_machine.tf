module "sfn_state_machine" {
  source = "../../modules/sfn_state_machine"

  name     = local.sfn_state_machine_name
  role_arn = module.iam_role_sfn.arn
  asl_definition = jsonencode({
    QueryLanguage = "JSONata"
    StartAt       = "S3PutEventState"
    States = {
      S3PutEventState = {
        Type = "Pass"
        End  = true
      }
    }
  })
}