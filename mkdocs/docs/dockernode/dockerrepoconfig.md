# Docker Repo Config

## Overview

This documentation outlines an Ansible playbook designed for DevOps engineers to automate the installation and setup of Docker on Ubuntu systems. The playbook includes tasks for adding Docker's official GPG key, printing architecture variables for informational purposes, and adding the Docker repository. Each task is explained in detail below, including the purpose of each task, the variables involved, and their outputs.

## Tasks Explanation

### 1. Add Docker's Official GPG Key

```yaml
- name: Add Docker's official GPG key
  ansible.builtin.apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    keyring: /etc/apt/keyrings/docker.gpg
    state: present
```

#### Description:
This task adds the official GPG key for Docker from Docker's website to the system's keyring. This is an essential step to ensure the authenticity of the Docker packages.

- **ansible.builtin.apt_key**: This module is used to add or remove APT keys.
- **url**: The URL to the GPG key that needs to be added.
- **keyring**: Specifies the keyring file where the GPG key will be stored.
- **state**: Defines the state of the key; `present` ensures the key is added.

### 2. Print Architecture Variables

```yaml
- name: Print architecture variables
  ansible.builtin.debug:
    msg: "Architecture: {{ ansible_architecture }}, Codename: {{ ansible_lsb.codename }}"
```

#### Description:
Prints the system's architecture and codename using Ansible's debug module. This is useful for verification and troubleshooting purposes.

- **ansible.builtin.debug**: This module is used for printing debug messages.
- **msg**: The message to print, which includes two Ansible facts:
  - **{{ ansible_architecture }}**: The architecture of the target system (e.g., x86_64).
  - **{{ ansible_lsb.codename }}**: The codename of the Linux distribution (e.g., bionic).

### 3. Add Docker Repository

```yaml
- name: Add Docker repository
  ansible.builtin.apt_repository:
    repo: >-
      deb [arch={{ arch_mapping[ansible_architecture] | default(ansible_architecture) }}
      signed-by=/etc/apt/keyrings/docker.gpg]
      https://download.docker.com/linux/ubuntu {{ ansible_lsb.codename }} stable
    filename: docker
    state: present
```

#### Description:
Adds the Docker repository to the system's package manager. This allows the system to install Docker packages from Docker's official repository.

- **ansible.builtin.apt_repository**: This module is used to add or remove APT repositories.
- **repo**: The repository line, which includes:
  - **arch=**: Specifies the architecture. It uses a mapping variable `arch_mapping` to translate `ansible_architecture` to the Docker repository's architecture format, with a fallback to `ansible_architecture` if no mapping is found.
  - **signed-by=**: Specifies the keyring file that contains the GPG key for verifying packages.
  - **https://download.docker.com/linux/ubuntu {{ ansible_lsb.codename }} stable**: The URL to the Docker repository, specifying the Linux distribution codename and the `stable` channel.
- **filename**: The name of the list file where the repository is saved.
- **state**: Ensures the repository is added to the system.

## Conclusion

This playbook provides a streamlined approach for DevOps engineers to automate the Docker installation process on Ubuntu systems. By adding Docker's official GPG key, ensuring the system's architecture and distribution codename are correctly identified, and adding the Docker repository, this playbook ensures a secure and reliable Docker setup. The use of Ansible's modules like `apt_key`, `debug`, and `apt_repository` simplifies the process, making it efficient and easy to maintain.