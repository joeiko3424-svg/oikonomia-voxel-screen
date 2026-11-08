provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "oikonomia_enclave" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Oikonomia-AirGapped-VPC"
  }
}

resource "aws_subnet" "isolated_subnet" {
  vpc_id            = aws_vpc.oikonomia_enclave.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Oikonomia-Isolated-Subnet"
  }
}

resource "aws_security_group" "enclave_sg" {
  name        = "oikonomia-enclave-sg"
  description = "Strict isolation for Oikonomia bare-metal evaluation"
  vpc_id      = aws_vpc.oikonomia_enclave.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_CORPORATE_IP/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["YOUR_CORPORATE_IP/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }
}

resource "aws_instance" "oikonomia_f2" {
  ami           = "ami-01d1583512f1afb46"
  instance_type = "f2.6xlarge"
  subnet_id     = aws_subnet.isolated_subnet.id
  vpc_security_group_ids = [aws_security_group.enclave_sg.id]

  tags = {
    Name = "Oikonomia-F2-Enclave"
  }
}
