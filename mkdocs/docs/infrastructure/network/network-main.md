# Terraform Configuration for AWS Networking Infrastructure

## Overview

This document outlines the Terraform configuration to set up a basic networking infrastructure on AWS for a DevOps engineer. The configuration includes the creation of a VPC, a public subnet, an internet gateway, a route table, and an association of the route table with the subnet. Below, each resource is explained with its code snippet and the significance of its properties.

## Resource: AWS VPC

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc"
  }
}
```

**Explanation:**

- `aws_vpc.main`: Declares a resource of type `aws_vpc` named `main`.
- `cidr_block`: Specifies the CIDR block for the VPC. The value is taken from the variable `var.vpc_cidr`, which should be defined in your variables file.
- `enable_dns_hostnames`: Enables DNS hostnames within the VPC. Setting this to `true` allows instances in the VPC to have a hostname.
- `tags`: A map of tags. Here, the VPC is tagged with the name "test-vpc".

## Resource: AWS Subnet

```hcl
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}
```

**Explanation:**

- `aws_subnet.public_subnet`: Declares a resource of type `aws_subnet` named `public_subnet`.
- `vpc_id`: Associates the subnet with a VPC, using the ID of the `aws_vpc.main` resource.
- `cidr_block`: Defines the CIDR block for the subnet, specified by `var.subnet_cidr`.
- `availability_zone`: Assigns the subnet to a specific availability zone, based on `var.availability_zone`.
- `map_public_ip_on_launch`: When set to `true`, instances launched in this subnet will be assigned a public IP address.
- `tags`: A map of tags, with the subnet tagged as "public-subnet".

## Resource: AWS Internet Gateway

```hcl
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-gateway"
  }
}
```

**Explanation:**

- `aws_internet_gateway.gw`: Creates an internet gateway resource named `gw`.
- `vpc_id`: Associates the internet gateway with the VPC created earlier.
- `tags`: Tags the internet gateway with the name "main-gateway".

## Resource: AWS Route Table

```hcl
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
```

**Explanation:**

- `aws_route_table.public_route_table`: Declares a route table resource named `public_route_table`.
- `vpc_id`: Associates the route table with the specified VPC.
- `route`: Defines a route in the route table. The `cidr_block` "0.0.0.0/0" represents all IP addresses, and `gateway_id` is the ID of the internet gateway, enabling internet access for the subnet.
- `tags`: Tags the route table with the name "public-route-table".

## Resource: AWS Route Table Association

```hcl
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
```

**Explanation:**

- `aws_route_table_association.public`: Creates an association between a subnet and a route table.
- `subnet_id`: The ID of the subnet to be associated.
- `route_table_id`: The ID of the route table to associate with the subnet.

## Conclusion

This Terraform configuration sets up a basic AWS networking infrastructure with a VPC, a public subnet, an internet gateway, and a route table to enable internet access. Each resource is tagged appropriately for easy identification. Ensure that you have defined the variables (`vpc_cidr`, `subnet_cidr`, `availability_zone`) in your variables file or pass them during runtime.
