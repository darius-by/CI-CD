resource "aws_security_group" "main-security-group" {
  name        = "main-security-group"
  description = "Security group for main VPC"
  vpc_id      = var.vpc_id

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
  cidr_blocks       = [var.web_access_cidr]
  security_group_id = aws_security_group.main-security-group.id
  description       = "WEB traffic to app"
}

resource "aws_security_group_rule" "ci_cd_to_docker_orchestration" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.ci_cd_public_ip}/32"]
  security_group_id = aws_security_group.main-security-group.id
  description       = "Jenkins to Docker Orchestration"
}

resource "aws_security_group_rule" "docker_orchestration_to_ci_cd" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.docker_public_ip}/32"]
  security_group_id = aws_security_group.main-security-group.id
  description       = "Docker Orchestration to Jenkins"
}

resource "aws_security_group_rule" "ssh_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.ssh_access_cidr]
  security_group_id = aws_security_group.main-security-group.id
  description       = "SSH access to all resources"
}

resource "aws_security_group_rule" "monitor_to_docker" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["${var.monitor_public_ip}/32"]
  security_group_id = aws_security_group.main-security-group.id
  description = "Monitoring and logging"
}