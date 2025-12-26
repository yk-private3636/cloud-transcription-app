module "terraform_role" {
  source = "../../modules/iam_role"

  name               = local.terraform_role_name
  assume_role_policy = data.aws_iam_policy_document.terraform_assume_role_policy.json
}

data "aws_iam_policy_document" "terraform_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:user/${var.terraform_iam_user_name}",
        "arn:aws:sts::${var.account_id}:assumed-role/${local.terraform_role_name}/GitHubActions"
      ]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.github_actions_openid_connect_provider.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${split("/", module.github_actions_openid_connect_provider.arn)[length(split("/", module.github_actions_openid_connect_provider.arn)) - 1]}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${split("/", module.github_actions_openid_connect_provider.arn)[length(split("/", module.github_actions_openid_connect_provider.arn)) - 1]}:sub"
      values   = ["repo:${var.github_owner}/${var.github_repo}:*"]
    }
  }
}