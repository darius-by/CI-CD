variable "vpc_id" {
  description = "The VPC ID for the security group"
}

variable "ci_cd_public_ip" {
  description = "Public IP for CI/CD instance"
}

variable "docker_public_ip" {
  description = "Public IP for Docker instance"
}

variable "web_access_cidr" {
  description = "CIDR block for web access"
}

variable "ssh_access_cidr" {
  description = "CIDR block for SSH access"
}

variable "monitor_public_ip" {
  description = "Public IP for Monitor instance"
}
