# Variables Configuration for AWS EC2 Security Groups

## Overview

This document outlines the Terraform configuration for setting up a security group within a Virtual Private Cloud (VPC) tailored for DevOps environments. It involves the declaration of variables representing the VPC ID, public IP addresses for CI/CD, Docker, and monitoring instances, as well as CIDR blocks for web and SSH access.

## Variables Declaration

Variables are declared in Terraform using the `variable` keyword. Each variable declared below is crucial for creating a customizable and reusable Terraform configuration.

### VPC ID

```hcl
variable "vpc_id" {
  description = "The VPC ID for the security group"
}
```

- **Description**: Specifies the ID of the VPC within which the security group will be created. This variable allows the Terraform configuration to be flexible and applicable to any VPC by providing its ID as an input.

### CI/CD Public IP

```hcl
variable "ci_cd_public_ip" {
  description = "Public IP for CI/CD instance"
}
```

- **Description**: Holds the public IP address of the Continuous Integration/Continuous Deployment (CI/CD) instance. This information is used to set up rules within the security group to allow or restrict access to the CI/CD instance.

### Docker Public IP

```hcl
variable "docker_public_ip" {
  description = "Public IP for Docker instance"
}
```

- **Description**: Contains the public IP address for the Docker instance. This is essential for configuring network access rules specific to the Docker environment within the security group.

### Web Access CIDR

```hcl
variable "web_access_cidr" {
  description = "CIDR block for web access"
}
```

- **Description**: Specifies the CIDR block that will be allowed web access to the instances within the VPC. This is crucial for setting up security group rules that control HTTP/HTTPS traffic.

### SSH Access CIDR

```hcl
variable "ssh_access_cidr" {
  description = "CIDR block for SSH access"
}
```

- **Description**: Defines the CIDR block from which SSH access is permitted. This variable is used to create security group rules that manage SSH connectivity, ensuring secure administrative access.

### Monitor Public IP

```hcl
variable "monitor_public_ip" {
  description = "Public IP for Monitor instance"
}
```

- **Description**: Represents the public IP address for the monitoring instance. This IP is used to configure access rules within the security group, allowing monitoring traffic to and from this instance.


## Conclusion

Through the use of variables in Terraform, DevOps engineers can create flexible, reusable, and maintainable infrastructure as code configurations. This document has provided the foundational knowledge to understand and utilize variables within Terraform for managing a security group in a VPC, specifically tailored for a DevOps setup.
