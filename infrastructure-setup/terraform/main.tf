provider "aws" {
  region = var.region
}

# Network Module
module "network" {
  source            = "./networking"
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
}

# Instances Module
module "instances" {
  source            = "./instances"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.network.subnet_id
  security_group_id = module.security.security_group_id
}

# Security Module
module "security" {
  source           = "./security"
  vpc_id           = module.network.vpc_id
  ci_cd_public_ip  = module.instances.ci_cd_eip
  docker_public_ip = module.instances.docker_eip
  monitor_public_ip = module.instances.monitor_eip
  web_access_cidr  = var.web_access_cidr
  ssh_access_cidr  = var.ssh_access_cidr
  
}
