module "iam_role_event" {
  source = "../../modules/iam_role"

  name               = local.event_role_name
  assume_role_policy = data.aws_iam_policy_document.event_assume_role_policy.json
}

data "aws_iam_policy_document" "event_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}