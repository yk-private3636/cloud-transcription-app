module "lambda_gen_nano_timestamp_iam_role" {
  source = "../../modules/iam_role"

  name               = local.lambda_function_gen_nano_timestamp_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_gen_nano_timestamp_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_gen_nano_timestamp_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}