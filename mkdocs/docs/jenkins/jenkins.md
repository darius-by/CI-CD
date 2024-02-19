# Installing Jenkins on Ubuntu Using Ansible

This document outlines the process of installing Jenkins on an Ubuntu server using Ansible, a powerful automation tool that simplifies complex IT tasks. This Ansible playbook is designed for DevOps engineers looking to automate the deployment of Jenkins within a CI/CD pipeline. Jenkins is an open-source automation server that enables developers to build, test, and deploy their applications efficiently.

## Overview

The Ansible playbook provided automates the installation of Jenkins on Ubuntu systems. It is structured into roles, each handling a specific part of the setup process. Below, we detail the playbook and the roles it encompasses.

## Playbook Structure

```yaml
- name: Install Jenkins on Ubuntu
  hosts: ci-cd
  become: true
  roles:
    - system-update
    - package-installation
    - docker-setup
    - docker-repo-config
    - docker-installation
    - docker-system-config
    - docker-compose
```

### Explanation

- **hosts: ci-cd**: This specifies the group of hosts targeted by the playbook. `ci-cd` should be defined in your Ansible inventory file, pointing to the server(s) where Jenkins will be installed.

- **become: true**: Elevates privileges to become the root user, which is necessary for installing packages and configuring the system.

- **roles**: A list of roles that the playbook will execute in order. Each role performs a specific task related to the Jenkins installation and Docker configuration.

### Roles Description

1. **system-update**: Updates all packages on the target system to their latest versions.
2. **package-installation**: Installs necessary packages that are prerequisites for Jenkins and Docker.
3. **docker-setup**: Prepares the system for Docker installation, including adding the Docker repository and its GPG key.
4. **docker-repo-config**: Configures the Docker repository for package installation.
5. **docker-installation**: Installs Docker, allowing the creation and management of Docker containers.
6. **docker-system-config**: Applies system-level configurations for Docker, such as adjusting network settings or setting up Docker daemon options.
7. **docker-compose**: Installs Docker Compose, a tool for defining and running multi-container Docker applications.


## Conclusion

By structuring the Jenkins installation process into roles, this Ansible playbook allows for modular, reusable, and easy-to-understand automation scripts. Each role encapsulates a set of tasks, making the playbook easier to maintain and adapt to different environments or requirements. For a successful execution, ensure your inventory file (`hosts` file in Ansible) is correctly set up with the `ci-cd` group and that all roles are properly defined with the necessary tasks.