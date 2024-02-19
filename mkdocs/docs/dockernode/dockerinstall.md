# Docker Install

This technical documentation outlines a step-by-step process for installing Docker and Docker Compose on a Ubuntu system, utilizing Ansible for automation. The process involves updating the system's package index, installing Docker and Docker Compose, ensuring Docker starts on boot, and adding a user to the Docker group for managing Docker as a non-root user. Each task is defined in a YAML format, compatible with Ansible playbooks, providing a structured and readable way to automate server configuration tasks.

## Overview

The script is divided into several tasks, each responsible for a specific part of the Docker and Docker Compose installation and configuration process. This guide will cover each task in detail, explaining the purpose of the commands, the expected outputs, and how they contribute to the Docker setup process.

### Task Descriptions and Code Snippets

#### 1. Update apt Package Index

```yaml
- name: Update apt package index
  apt:
    update_cache: yes
```

**Description**: This task updates the package index cache of the APT package manager to ensure that it has the latest information about available packages and their versions.

**Expected Output**: The package index on the target machine will be updated. This step does not produce a visible output in Ansible's default configuration but is essential for ensuring subsequent package installations use the latest available versions.

#### 2. Install Docker.io

```yaml
- name: Install Docker.io
  apt:
    name: docker.io
    state: present
```

**Description**: Installs the `docker.io` package, which contains Docker, from the Ubuntu package repository. The `state: present` ensures that Docker is installed but does not upgrade it if it's already installed.

**Expected Output**: Docker will be installed on the target machine. The output will indicate that the `docker.io` package has been installed successfully.

#### 3. Install Docker Compose

```yaml
- name: Install Docker Compose
  apt:
    name: docker-compose-plugin
    state: present
```

**Description**: This task installs the `docker-compose-plugin`, allowing the use of Docker Compose to define and run multi-container Docker applications. The use of the Docker Compose plugin simplifies the process of managing application stacks.

**Expected Output**: Docker Compose will be installed on the target machine. The output will confirm the successful installation of the `docker-compose-plugin` package.

#### 4. Start Docker and Enable on Boot

```yaml
- name: Start Docker and enable on boot
  systemd:
    name: docker
    enabled: yes
    state: started
```

**Description**: Ensures that the Docker service is started and set to launch on boot. This uses the `systemd` module to manage the Docker service, making sure it's actively running and enabled to start automatically at system startup.

**Expected Output**: Docker will be started and enabled to automatically start on system boot. This task confirms that Docker will be running and ready to use after installation and after each system reboot.

#### 5. Add Ubuntu User to Docker Group

```yaml
- name: Add ubuntu user to docker group
  user:
    name: ubuntu
    groups: docker
    append: yes
```

**Description**: Adds the `ubuntu` user to the `docker` group, allowing the user to execute Docker commands without needing superuser privileges. This is a security best practice, as running Docker as a non-root user reduces the risk of unwanted system changes or security breaches.

**Expected Output**: The `ubuntu` user will be added to the `docker` group. This change permits the `ubuntu` user to run Docker commands without using `sudo`.

## Conclusion

By following the steps outlined in this guide, DevOps engineers can automate the installation and configuration of Docker and Docker Compose on Ubuntu systems using Ansible. This approach not only simplifies the setup process but also ensures consistency and repeatability across multiple environments, reducing potential errors and saving time.