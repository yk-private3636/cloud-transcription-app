module "aws_cloudwatch_event_target" {
  source = "../../modules/cloudwatch_event_target"

  rule_name  = module.cloudwatch_event_rule.name
  target_id  = module.sfn_state_machine.name
  target_arn = module.sfn_state_machine.arn
  role_arn   = module.iam_role_event.arn
}