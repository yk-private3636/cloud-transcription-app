module "lambda_transcription_job_reader_permission" {
  source = "../../modules/lambda_permission"

  action         = "lambda:InvokeFunction"
  function_name  = module.transcription_job_reader_function.name
  principal      = "states.amazonaws.com"
  source_account = var.account_id
  source_arn     = module.sfn_state_machine.arn
}