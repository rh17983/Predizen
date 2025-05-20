provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.deploy_key.public_key_openssh
}

resource "aws_security_group" "fastapi_http" {
  name        = "fastapi-allow-http"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id  # or your custom VPC

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # allow from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "fastapi_server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.fastapi_http.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install docker git -y
              service docker start
              usermod -a -G docker ec2-user
              cd /home/ec2-user
              git clone https://github.com/${var.github_repo}.git app
              cd app
              docker build -t fastapi-app .
              docker run -d -p 80:80 fastapi-app
              EOF

  tags = {
    Name = "FastAPIApp"
  }
}

output "public_ip" {
  value = aws_instance.fastapi_server.public_ip
}

output "private_key" {
  value     = tls_private_key.deploy_key.private_key_pem
  sensitive = true
}