terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = "AKIARHP5AA3HESI76H7S"
  secret_key = "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"
}

