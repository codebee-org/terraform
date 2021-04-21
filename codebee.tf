provider "aws" {
  version = "~> 3.00"
  region  = var.region
}

terraform {
  backend "remote" {
    organization = "codebee"

    workspaces {
      name = "codebee-prod"
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "codebee-getting-started-terraform"
  acl    = "private"
}
