locals {
  name                   = "${var.env}-${var.project_name}"
  s3_put_event_name      = "${local.name}-s3-put-event"
  sfn_state_machine_name = "${local.name}-state-machine"
  sfn_role_name          = "${local.name}-sfn-role"
  event_role_name        = "${local.name}-event-role"
  event_policy_name      = "${local.name}-event-policy"
}