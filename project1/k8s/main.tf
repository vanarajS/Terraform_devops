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

module "instance" {
    source = "./modules/aws_instance"
    public_key_path    = "./ssh-key"
    os_name            = "ami-069e612f612be3a2b"
    aws_instance_count = 2
    instance_type      = "t2.micro"
    subnet_id          = module.vpc.subnet_ids
    vpc_main_id        = module.vpc.vpc_main_id
    app-testing        = "./Ansible_user_data.sh"
    security_group_ids = [ module.sg.sg_22, module.sg.sg_80 ]
    ec2_name           = ["master01", "worker01"]
}

output "instance" {
  value = module.instance.instance_public_ip
}