provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "main-security-group" {
  name        = "main-security-group"
  description = "Security group for main VPC"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "web_access" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["78.61.94.80/32"]
  security_group_id = aws_security_group.main-security-group.id
  description       = "WEB traffic to app"
}

resource "aws_security_group_rule" "jenkins_to_docker_orchestration" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["13.48.249.124/32"]
  security_group_id = aws_security_group.main-security-group.id
  description       = "Jenkins to Docker Orchestration"
}

resource "aws_security_group_rule" "docker_orchestration_to_jenkins" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["16.171.145.22/32"]
  security_group_id = aws_security_group.main-security-group.id
  description       = "Docker Orchestration to Jenkins"
}

resource "aws_security_group_rule" "ssh_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["78.61.94.80/32"]
  security_group_id = aws_security_group.main-security-group.id
  description       = "SSH access to all resources"
}

resource "aws_instance" "ci_cd" {
  ami           = "ami-0fe8bec493a81c7da"
  instance_type = "t3.micro"
  key_name      = "k8s"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.main-security-group.id]

  tags = {
    Name = "CI-CD"
  }
}

resource "aws_instance" "docker" {
  ami           = "ami-0fe8bec493a81c7da"
  instance_type = "t3.micro"
  key_name      = "k8s"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.main-security-group.id]

  tags = {
    Name = "Docker"
  }
}
