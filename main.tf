provider "aws" {
  region     = "eu-west-3"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "DC3-HK-LP1" {
  ami           = "ami-0302f42a44bf53a45"
  instance_type = "t2.micro"

  # Associer le groupe de sécurité à cette instance
  vpc_security_group_ids = [aws_security_group.HK_web.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "Hello Terraform" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Instance Ubuntu avec Apache"
  }
}

resource "aws_security_group" "HK_web" {
  name        = "HK-web"
  description = "Autoriser le trafic HTTP"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser également le trafic SSH pour pouvoir se connecter à l'instance
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
