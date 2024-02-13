variable "region" {
  description = "The AWS region to deploy resources into"
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  default     = "ami-0fe8bec493a81c7da"
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  default     = "t3.micro"
}

variable "key_name" {
  description = "The key name for the EC2 instances"
  default     = "k8s"
}

variable "web_access_cidr" {
  description = "CIDR block for web access"
  default     = "78.61.94.80/32"
}

variable "ssh_access_cidr" {
  description = "CIDR block for SSH access"
  default     = "78.61.94.80/32"
}
variable "availability_zone" {
  description = "The availability zone for the subnet"
  default     = "eu-north-1a"
}
