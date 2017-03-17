provider "aws" {
    region  = "us-east-1"
    profile = "terraform"
}


resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-up-and-running-state-iliyahoo"
    versioning {
        enabled = true
    }
    lifecycle {
        prevent_destroy = true
    }
}
