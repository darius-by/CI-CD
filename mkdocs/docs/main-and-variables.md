# AWS Infrastructure Deployment Using Terraform

### Overview

Terraform is an Infrastructure as Code (IaC) tool that allows for the automated deployment and management of cloud resources. The provided Terraform configuration files are structured to deploy resources within AWS, including a Virtual Private Cloud (VPC), subnets, EC2 instances, and security groups.

### Provider Configuration

First, specify the provider and region. Terraform uses providers to interact with cloud service APIs. The `aws` provider block configures Terraform to use the Amazon Web Services (AWS) provider.

```hcl
provider "aws" {
  region = var.region
}
```

- `region`: Specifies the AWS region where resources will be deployed. Its value is retrieved from a variable `var.region`, which is defined later in the variables section.

### Network Module

The network module sets up the VPC and subnet configurations.

```hcl
module "network" {
  source            = "./networking"
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
}
```

- `source`: The path to the network module's code.
- `vpc_cidr`: The CIDR block for the VPC, obtained from `var.vpc_cidr`.
- `subnet_cidr`: The CIDR block for the subnet within the VPC, sourced from `var.subnet_cidr`.
- `availability_zone`: Specifies the availability zone for the subnet, derived from `var.availability_zone`.

### Instances Module

The instances module configures EC2 instances within the network created by the network module.

```hcl
module "instances" {
  source            = "./instances"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.network.subnet_id
  security_group_id = module.security.security_group_id
}
```

- `ami_id`: The Amazon Machine Image (AMI) ID for the instances.
- `instance_type`: Specifies the type of EC2 instance to deploy.
- `key_name`: The name of the SSH key pair used for instance access.
- `subnet_id`: The subnet ID where instances will be placed, referencing the `subnet_id` output from the `network` module.
- `security_group_id`: Associates instances with a security group, referencing the `security_group_id` output from the `security` module.

### Security Module

The security module is responsible for creating security groups and defining access rules.

```hcl
module "security" {
  source           = "./security"
  vpc_id           = module.network.vpc_id
  ci_cd_public_ip  = module.instances.ci_cd_eip
  docker_public_ip = module.instances.docker_eip
  monitor_public_ip = module.instances.monitor_eip
  web_access_cidr  = var.web_access_cidr
  ssh_access_cidr  = var.ssh_access_cidr
}
```

- `vpc_id`: The VPC ID to which the security group belongs, referencing the `vpc_id` output from the `network` module.
- `*_public_ip`: Placeholder variables for public IPs of specific services (CI/CD, Docker, Monitoring), intended to be replaced with actual IPs or removed if not applicable.
- `web_access_cidr`: Specifies the CIDR block allowed for web access.
- `ssh_access_cidr`: Defines the CIDR block allowed for SSH access.

## Variables

Variables allow the configuration to be reusable and dynamic. Define variables and their default values to specify the AWS region, network settings, EC2 instance configurations, and access rules.

```hcl
variable "region" {
  description = "The AWS region to deploy resources into"
  default     = "eu-north-1"
}
```

- Each `variable` block defines a single variable. The `description` field is optional but recommended for clarity.
- The `default` field specifies a default value if none is provided at runtime.


### Detailed Variable Descriptions

#### `vpc_cidr`

```hcl
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
```

- **Description**: Defines the range of IP addresses for the VPC. This determines how large the VPC is and how many IP addresses are available for resources within it.

#### `subnet_cidr`

```hcl
variable "subnet_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}
```

- **Description**: Specifies the CIDR block for a subnet within the VPC. This determines the subnet's size and the range of IP addresses that can be assigned to resources within this subnet.

#### `ami_id`

```hcl
variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  default     = "ami-0fe8bec493a81c7da"
}
```

- **Description**: Identifies the Amazon Machine Image (AMI) used to launch EC2 instances. This determines the OS and initial state of the instances.

#### `instance_type`

```hcl
variable "instance_type" {
  description = "The instance type for the EC2 instances"
  default     = "t3.micro"
}
```

- **Description**: Defines the type of EC2 instance to launch. This affects the compute and memory capacity of the instances, impacting performance and cost.

#### `key_name`

```hcl
variable "key_name" {
  description = "The key name for the EC2 instances"
  default     = "k8s"
}
```

- **Description**: Specifies the name of the SSH key pair to be used for secure access to the instances. This key must exist in the specified AWS region.

#### `web_access_cidr`

```hcl
variable "web_access_cidr" {
  description = "CIDR block for web access"
  default     = "78.61.94.80/32"
}
```

- **Description**: Determines the CIDR block allowed to access web services running on the instances. Typically used to restrict access to a specific IP range for security.

#### `ssh_access_cidr`

```hcl
variable "ssh_access_cidr" {
  description = "CIDR block for SSH access"
  default     = "78.61.94.80/32"
}
```

- **Description**: Defines the CIDR block permitted to initiate SSH connections to the instances. This is crucial for securing remote access.

#### `availability_zone`

```hcl
variable "availability_zone" {
  description = "The availability zone for the subnet"
  default     = "eu-north-1a"
}
```

- **Description**: Specifies the Availability Zone (AZ) where the subnet will be located. AZs are distinct locations within a region that are engineered to be isolated from failures in other AZs.


### Conclusion

This Terraform configuration demonstrates a basic setup for deploying a network, instances, and security groups in AWS. It's modular, allowing for easy updates and scalability. Variables make the configuration flexible, while modules encapsulate specific resource setups, promoting reusability and maintainability.

