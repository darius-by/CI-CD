resource "aws_instance" "ci_cd" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "CI-CD"
  }
}

resource "aws_eip" "ci_cd_eip" {
  instance = aws_instance.ci_cd.id
}

resource "aws_instance" "docker" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "Docker"
  }
}

resource "aws_eip" "docker_eip" {
  instance = aws_instance.docker.id
}

resource "aws_instance" "monitor" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "Monitor"
  }
}

resource "aws_eip" "monitor_eip" {
  instance = aws_instance.monitor.id
}
