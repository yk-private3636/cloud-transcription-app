module "s3_put_event_target" {
  source = "../../modules/cloudwatch_event_target"

  rule_name  = module.s3_put_event_rule.name
  target_id  = module.sfn_state_machine.name
  target_arn = module.sfn_state_machine.arn
  role_arn   = module.s3_put_event_iam_role.arn
}