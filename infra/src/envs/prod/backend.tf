terraform {
  required_version = ">= 1.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "cloud-transcription-app-tfstate"
    key          = "prod/terraform.state"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
