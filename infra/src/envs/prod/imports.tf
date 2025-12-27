import {
  to = module.executor_role.aws_iam_role.main
  identity = {
    "name" = local.executor_role_name
  }
}