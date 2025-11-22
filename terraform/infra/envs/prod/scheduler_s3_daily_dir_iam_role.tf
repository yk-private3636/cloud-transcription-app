module "scheduler_s3_daily_dir_iam_role" {
  source = "../../modules/iam_role"

  name               = local.scheduler_s3_daily_dir_role_name
  assume_role_policy = data.aws_iam_policy_document.scheduler_s3_daily_dir_assume_role_policy.json
}

data "aws_iam_policy_document" "scheduler_s3_daily_dir_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}