//Using this region to deploy freely t2.micro
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow HTTP, Jenkins, and SSH"

  ingress {
    description = "HTTP for app"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "For Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "For SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "For all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_ec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 22.04 in us-east-1
  instance_type          = "t2.micro"
  key_name               = "itzik-key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y && \
              apt-get install -y openjdk-17-jdk maven docker.io curl gnupg && \
              systemctl start docker && \
              systemctl enable docker && \
              docker pull itzikgalanti/deployment-demo:latest && \
              docker run -d -p 80:8080 itzikgalanti/deployment-demo && \
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null && \
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null && \
              apt-get update -y && \
              apt-get install -y jenkins && \
              systemctl start jenkins && \
              systemctl enable jenkins
            EOF

  tags = {
    Name = "Dev-Task"
  }
}
