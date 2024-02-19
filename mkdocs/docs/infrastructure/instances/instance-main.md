# AWS EC2 Instance Deployment

This document outlines the Terraform configuration for setting up a DevOps environment in AWS. It includes the creation of EC2 instances for Continuous Integration/Continuous Deployment (CI/CD), Docker, and monitoring purposes, along with the association of Elastic IP addresses (EIPs) to these instances for stable IP addressing. Each section of the code is explained in detail, including variables, resources, and expected outputs.

## Overview

The Terraform script is designed to provision three Amazon EC2 instances, each serving a different role within a DevOps setup:

1. **CI/CD Server**: Automates the process of software delivery and infrastructure changes.
2. **Docker Server**: Hosts Docker containers, enabling the creation, deployment, and running of applications in isolated environments.
3. **Monitoring Server**: Monitors the health and performance of the infrastructure and applications.

Each server is assigned an Elastic IP to ensure a persistent public IP address for reliable access and integration with other services.

### Prerequisites

- Terraform installed and configured
- AWS Account and CLI configured with appropriate permissions
- Variable definitions (`ami_id`, `instance_type`, `key_name`, `subnet_id`, `security_group_id`) are correctly set up in Terraform variables file

## Resource Configuration

### AWS Instance for CI/CD

```hcl
resource "aws_instance" "ci_cd" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "CI-CD"
  }
}
```

- **ami**: The Amazon Machine Image ID that defines the software configuration (including the operating system and installed applications) of the instance.
- **instance_type**: The type of instance (e.g., `t2.micro`), affecting the compute and memory capacity.
- **key_name**: The name of the key pair for secure SSH access to the instance.
- **subnet_id**: The ID of the subnet within the Virtual Private Cloud (VPC).
- **vpc_security_group_ids**: A list of security group IDs to assign to the instance, controlling access to and from the instance.
- **tags**: Key-value pairs for resource identification, with `"Name"` set to `"CI-CD"` for easy identification.

### Elastic IP for CI/CD Instance

```hcl
resource "aws_eip" "ci_cd_eip" {
  instance = aws_instance.ci_cd.id
}
```

- **instance**: Associates the Elastic IP with the CI/CD instance by referencing its ID. This ensures the CI/CD server has a stable, public IP address.

### AWS Instance for Docker

```hcl
resource "aws_instance" "docker" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "Docker"
  }
}
```

This configuration mirrors the CI/CD instance setup, with the "Name" tag set to "Docker" to denote its role.

### Elastic IP for Docker Instance

```hcl
resource "aws_eip" "docker_eip" {
  instance = aws_instance.docker.id
}
```

Similar to the CI/CD instance, this assigns an Elastic IP to the Docker instance for persistent public IP addressing.

### AWS Instance for Monitoring

```hcl
resource "aws_instance" "monitor" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "Monitor"
  }
}
```

This setup is for the monitoring server, tagged as "Monitor" to indicate its purpose.

### Elastic IP for Monitoring Instance

```hcl
resource "aws_eip" "monitor_eip" {
  instance = aws_instance.monitor.id
}
```

Ensures the monitoring server has a consistent public IP address by associating it with an Elastic IP.

## Expected Outputs

After applying this Terraform configuration, you should have three EC2 instances running, each with a dedicated role in the DevOps lifecycle. Elastic IPs associated with these instances provide stable, public IP addresses for external access and integration.

- **CI/CD Server**: Hosts Jenkins CI CD tools for automating the software delivery process.
- **Docker Server**: Runs Docker containers, facilitating consistent, lightweight, and secure application deployment.
- **Monitoring Server**: Implements monitoring solutions Prometheus and Grafana to track system performance and health.

