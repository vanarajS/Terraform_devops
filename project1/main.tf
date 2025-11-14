provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source          = "./modules/vpc"
  cidr_block =  "12.0.0.0/16"
  vpc_name = "vpc-main"
  sub_region = ["us-east-1a", "us-east-1b"]
  subnet_count = 2
  subnet_cidr = ["12.0.1.0/24", "12.0.2.0/24"]
}