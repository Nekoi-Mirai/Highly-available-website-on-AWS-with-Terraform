terraform {
  required_version = ">= 1.2.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.20.1"
    }
  }
}

provider aws {
  region  = "ap-southeast-2"

  default_tags {
    tags = {
      project: "Cloud-Resume"
    }
  }
}