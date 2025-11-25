module "lambda_s3_content_iam_role" {
  source = "../../modules/iam_role"

  name               = local.lambda_function_s3_content_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_s3_content_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_s3_content_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}