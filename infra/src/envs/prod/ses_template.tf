module "ses_success_template" {
  source = "../../modules/ses_template"

  name    = local.ses_success_template_name
  subject = "【音声議事録】文字起こし結果のお知らせ"
  text    = <<EOF

{{fileName}} の議事録をお送りします。

実際の議事録は添付ファイルをご確認ください。

※ この議事録は AI により自動生成されています。

  EOF
}

module "ses_fail_template" {
  source = "../../modules/ses_template"

  name    = local.ses_fail_template_name
  subject = "【音声議事録】文字起こし処理エラーのお知らせ"
  text    = <<EOF

{{fileName}} の文字起こし処理中にエラーが発生しました。

実行ID: {{executionId}}

エラーメッセージ: {{errorMessage}}

問題が解決しない場合は、システム管理者にお問い合わせください。

※ このメールは自動送信されています。

  EOF
}