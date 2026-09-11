terraform {
  backend "s3" {
  }
  required_version = ">= 1.16"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.62"
    }
  }
}

provider "aws" {
  region = var.region
}