provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "fastapi_server" {
  ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = var.key_name  # SSH key pair name

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

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

output "public_ip" {
  value = aws_instance.fastapi_server.public_ip
}
