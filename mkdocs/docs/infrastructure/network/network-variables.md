# Variables Configuration for AWS EC2 Networking

### Overview

This document provides an in-depth explanation of Terraform code snippets used to define variables within an Infrastructure as Code (IaC) context. These variables are essential for creating a Virtual Private Cloud (VPC) and its subnet within AWS, specifying network ranges and the deployment location.

### Variables Definition

#### VPC CIDR Variable

```hcl
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
```

- **Description**: Defines the CIDR (Classless Inter-Domain Routing) block for the Virtual Private Cloud (VPC).
- **Variable Name**: `vpc_cidr`
- **Default Value**: `10.0.0.0/16` - This represents a network block with 65,536 IP addresses (from `10.0.0.0` to `10.0.255.255`), suitable for a large-scale network.
- **Usage**: This variable allows users to specify the IP address range for the entire VPC, facilitating network segmentation and management within AWS.

#### Subnet CIDR Variable

```hcl
variable "subnet_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}
```

- **Description**: Specifies the CIDR block for a subnet within the VPC, designed for public-facing resources.
- **Variable Name**: `subnet_cidr`
- **Default Value**: `10.0.1.0/24` - This defines a subnet with 256 IP addresses (from `10.0.1.0` to `10.0.1.255`), typically used for smaller, segregated sections of the network.
- **Usage**: This variable is critical for defining sub-networks within the VPC that can host resources requiring external access, like web servers.

#### Availability Zone Variable

```hcl
variable "availability_zone" {
  description = "The availability zone for the subnet"
  default     = "eu-north-1a"
}
```

- **Description**: Identifies the AWS Availability Zone (AZ) where the subnet will be located.
- **Variable Name**: `availability_zone`
- **Default Value**: `eu-north-1a` - Indicates the specific AZ within the `eu-north-1` region. AWS regions are geographical locations, while AZs are isolated locations within a region designed to provide high availability.
- **Usage**: This variable ensures that resources within the subnet are deployed in a specific, geographically isolated section of the AWS cloud, aiding in disaster recovery and high availability strategies.


### Conclusion

By defining and utilizing these variables, DevOps engineers can create flexible, scalable, and configurable infrastructure as code. This approach enhances code reuse, simplifies configuration management, and aids in the deployment of reliable and consistent environments across development, testing, and production stages.
