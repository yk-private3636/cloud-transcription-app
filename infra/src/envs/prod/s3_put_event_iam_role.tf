module "s3_put_event_iam_role" {
  source = "../../modules/iam_role"

  name               = local.s3_put_event_role_name
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