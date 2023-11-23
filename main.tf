module "vpc" {
  source             = "./vpc-module"
  cidr_block         = "10.0.0.0/16"
  subnet_cidr_block  = "10.0.1.0/24"
  availability_zone  = "eu-west-3a"
}

module "ec2" {
  source            = "./ec2-module"
  ami_id            = "ami-0302f42a44bf53a45"
  instance_type     = "t2.micro"
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.vpc.security_group_id
  vpc_id            = module.vpc.vpc_id
}
