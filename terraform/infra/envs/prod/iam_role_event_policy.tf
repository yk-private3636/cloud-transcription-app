module "iam_role_policy" {
  source = "../../modules/iam_role_policy"

  name    = local.event_policy_name
  role_id = module.iam_role_event.id
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution"
        ]
        Resource = module.sfn_state_machine.arn
      }
    ]
  })
}