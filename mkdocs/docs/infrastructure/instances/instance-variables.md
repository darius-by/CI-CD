# Variables Configuration for AWS EC2 Instances

This document provides a detailed technical overview and guidance for DevOps engineers on provisioning AWS EC2 instances using Terraform. The Terraform configuration includes the declaration of necessary variables to customize the deployment, such as AMI ID, instance type, key name, subnet ID, and security group ID. Each variable is crucial for defining the properties of the EC2 instances you intend to launch as part of your infrastructure.

## Variables Declaration

Variables in Terraform are used to parameterize configurations, making them reusable and flexible. Below are the declarations for variables required to provision EC2 instances:

### `ami_id`

```hcl
variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
}
```

- **Description**: Specifies the Amazon Machine Image (AMI) ID that will be used for the EC2 instances. The AMI determines the OS and software configuration of the instances you launch.
- **Type**: `string`
- **Required**: Yes

### `instance_type`

```hcl
variable "instance_type" {
  description = "The instance type for the EC2 instances"
}
```

- **Description**: Defines the instance type of the EC2 instances. This affects computing capabilities, memory, and networking resources available to the instance.
- **Type**: `string`
- **Required**: Yes

### `key_name`

```hcl
variable "key_name" {
  description = "The key name for the EC2 instances"
}
```

- **Description**: Identifies the name of the Key Pair to be used for SSH access to the instances. You must create or import a Key Pair in the AWS Management Console before specifying it here.
- **Type**: `string`
- **Required**: Optional (but necessary for SSH access)

### `subnet_id`

```hcl
variable "subnet_id" {
  description = "The subnet ID for the EC2 instances"
}
```

- **Description**: Specifies the ID of the subnet where the EC2 instances will be launched. This determines the VPC and availability zone in which the instances will reside.
- **Type**: `string`
- **Required**: Yes

### `security_group_id`

```hcl
variable "security_group_id" {
  description = "The security group ID for the EC2 instances"
}
```

- **Description**: Specifies the security group ID to be associated with the EC2 instances. Security groups act as virtual firewalls that control the traffic to and from instances.
- **Type**: `string`
- **Required**: Yes

## Example Usage

To utilize these variables in a Terraform configuration, you would reference them within your resources block. Below is an example of how to define an AWS EC2 instance resource using these variables:

```hcl
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "ExampleInstance"
  }
}
```

- **Description**: This resource block creates an AWS EC2 instance with the specified configurations.
- **`ami`**: Utilizes the `ami_id` variable to set the AMI for the instance.
- **`instance_type`**: Uses the `instance_type` variable to determine the instance's computing capacity.
- **`key_name`**: Applies the `key_name` variable to enable SSH access using the specified Key Pair.
- **`subnet_id`**: Places the instance within the specified subnet by using the `subnet_id` variable.
- **`vpc_security_group_ids`**: Attaches the specified security group to the instance for network traffic control.

## Conclusion

This comprehensive approach ensures that DevOps engineers have the necessary context and examples to effectively use Terraform for managing AWS EC2 instances, enhancing automation and infrastructure as code practices.
