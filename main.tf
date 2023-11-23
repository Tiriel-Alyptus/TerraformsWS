provider "aws" {
  region = "eu-west-3"
  access_key = "AKIARDPIV56EDNXA4JXX"
  secret_key = "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"
}

resource "aws_instance" "DC3-HK-T3" {
  ami           = "ami-0302f42a44bf53a45"
  instance_type = "t2.micro"
}
