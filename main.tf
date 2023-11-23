    provider "aws" {
      region = "eu-west-3"
      access_key = "*"
      secret_key = "*"
    }
    
    resource "aws_instance" "DC3-HK-T3" {
      ami           = "ami-0302f42a44bf53a45"
      instance_type = "t2.micro"
    }