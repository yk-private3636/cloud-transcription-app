module "bedrock_iam_role" {
  source = "../../modules/iam_role"

  name               = local.bedrock_role_name
  assume_role_policy = data.aws_iam_policy_document.bedrock_assume_role_policy.json
}

data "aws_iam_policy_document" "bedrock_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:bedrock:${var.aws_region[0]}:${var.account_id}:model-invocation-job-job/*"
      ]
    }
  }
}