terraform {

required_providers {
  aws = {
    source = "hashicorp/aws"
    version = "3.63.0"
  }

  kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.6.1"
  }
}

  required_version = ">= 1.0.10"
}

provider "aws" {
  region = var.region
}
