module "lambda_gen_nano_timestamp_permission" {
  source = "../../modules/lambda_permission"

  action         = "lambda:InvokeFunction"
  function_name  = module.gen_nano_timestamp_function.name
  principal      = "states.amazonaws.com"
  source_account = var.account_id
  source_arn     = module.sfn_state_machine.arn
}