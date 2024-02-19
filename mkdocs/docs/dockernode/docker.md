# Setup Docker, GPG, Monitoring Tools and Docker Credential Helper on EC2 Instances

## Overview
This document outlines the steps to configure Docker, GPG (GNU Privacy Guard), and Docker Credential Helper on EC2 instances using Ansible. The process involves configuring Docker repositories, installing Docker, setting up GPG for secure communication, and configuring Docker Credential Helper to safely store Docker logins. Additionally, cAdvisor, Node Exporter and Docker Compose are installed for container monitoring and multi-container Docker applications management, respectively.

## Ansible Playbook Explanation

### Playbook Structure
The playbook is an Ansible YAML file that automates the setup process across all specified EC2 instances within the `docker` group. The `become: true` directive escalates privileges to run tasks that require root access.

```yaml
- name: Setup Docker, GPG, and Docker Credential Helper on EC2 Instances
  hosts: docker
  become: true
  roles:
    - docker-repo-config
    - docker-setup
    - docker-install
    - gpg-setup
    - docker-credential-helper
    - cadvisor
    - docker-compose
```

### Roles Breakdown
1. **docker-repo-config**: Configures Docker repositories to ensure the installation of the latest Docker version.
2. **docker-setup**: Prepares the system for Docker installation, including installing dependencies and adding the Docker group.
3. **docker-install**: Installs Docker and starts the Docker service.
4. **gpg-setup**: Installs GPG and configures key management for secure communication.
5. **docker-credential-helper**: Installs Docker Credential Helper to securely store Docker registry credentials.
6. **cadvisor**: Installs and configures cAdvisor and Node Exporter for real-time container and server node monitoring.
7. **docker-compose**: Runs Docker Compose script to deploy multi-container Docker applications through a YAML file.


## Conclusion
This playbook automates the setup of Docker, GPG, Docker Credential Helper, cAdvisor, Node Exporter, and Docker Compose on EC2 instances. 