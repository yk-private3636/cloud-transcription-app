module "github_actions_openid_connect_provider" {
  source = "../../modules/iam_openid_connect_provider"

  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}