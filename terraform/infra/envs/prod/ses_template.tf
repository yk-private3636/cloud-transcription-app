module "ses_template" {
  source = "../../modules/ses_template"

  name    = local.ses_template_name
  subject = "【音声議事録】文字起こし結果のお知らせ"
  text    = <<EOF

{{fileName}} の議事録をお送りします。

詳細な文字起こし結果は添付ファイルをご確認ください。

※ この議事録は AI により自動生成されています。

  EOF
}