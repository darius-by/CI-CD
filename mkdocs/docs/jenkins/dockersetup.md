# Docker Setup

## Overview

This document outlines the steps for setting up a Jenkins server with Docker capabilities, facilitated by Ansible for automation and Docker Compose for container orchestration. The process involves preparing the environment by creating necessary directories with the correct permissions, copying the Docker Compose file to the host machine, and configuring a Docker Compose service for Jenkins.

## Ansible Playbook

The Ansible playbook comprises three tasks aimed at preparing the environment on a host machine for Jenkins and Docker integration.

### Task 1: Create Directory for Docker's GPG Key

```yaml
- name: Create directory for Docker's GPG key
  ansible.builtin.file:
    path: /etc/apt/keyrings
    state: directory
    mode: '0755'
```

**Description:**
This task ensures the existence of a directory at `/etc/apt/keyrings` with the appropriate permissions. This directory is intended to store the GPG key for Docker, which is a security measure for verifying the authenticity of downloaded packages.

- `path`: Specifies the directory location.
- `state`: Ensures the directory exists.
- `mode`: Sets the directory's permissions to `0755`, allowing read, write, and execute access for the owner, and read and execute access for group and others.

### Task 2: Create Directory for Jenkins Home Folder

```yaml
- name: Create directory for Jenkins home folder
  ansible.builtin.file:
    path: /home/ubuntu/jenkins_data
    state: directory
    mode: '0755'
    owner: '1000'
    group: '1000'
```

**Description:**
Creates a directory for storing Jenkins data, ensuring it has the correct permissions and ownership. This directory acts as the Jenkins home, storing configurations, jobs, and other persistent data.

- `path`: The location of the Jenkins data directory.
- `state`: Ensures the directory is present.
- `mode`: Sets permissions to `0755`.
- `owner`: Specifies the user ID that owns the directory.
- `group`: Specifies the group ID for the directory.

### Task 3: Copy Docker Compose File and Set Permissions

```yaml
- name: Copy Docker compose file and set permissions
  ansible.builtin.copy:
    src: ./docker-setup/files/docker-compose.yaml
    dest: /home/ubuntu
    mode: '0755'
    owner: '1000'
    group: '1000'
```

**Description:**
This task copies the Docker Compose file from a local directory to the target machine and sets the appropriate permissions and ownership. This file is crucial for defining and running multi-container Docker applications.

- `src`: The source path of the Docker Compose file on the local machine.
- `dest`: The destination path on the target machine.
- `mode`: Sets the file permissions to `0755`.
- `owner`: Sets the owner of the file.
- `group`: Sets the group of the file.

## Docker Compose File

The Docker Compose file defines the configuration for a Jenkins service running in a Docker container with Docker support enabled.

```yaml
version: '3.8'
services:
  jenkins:
    image: dariusby/jenkins-w-docker:5
    container_name: jenkins
    user: "1000:999"
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /home/ubuntu/jenkins_data:/var/jenkins_home
    restart: always
```

**Description:**
- `version`: Specifies the version of the Docker Compose file format.

- `services`: Defines the configured services. In this case, a single `jenkins` service.

- `image`: The Docker image to use for the Jenkins container.

- `container_name`: Sets a custom name for the container.

- `user`: Specifies the user and group ID under which the container will run.

- `ports`: Maps port `8080` on the host to port `8080` in the container for web interface access, and port `50000` for Jenkins agent connections.

- `volumes`: Mounts the Docker socket and Jenkins data directory into the container. This enables Docker command execution from within the Jenkins container.

- `restart`: Configures the restart policy for the container. `always` ensures the container restarts after crashes or system reboots.


## Conclusion

The steps detailed in this document illustrate a methodical approach to deploying Jenkins in a Docker environment using Ansible for environment setup and Docker Compose for service definition. By automating environment preparation and Jenkins configuration, DevOps engineers can streamline their CI/CD workflows, ensuring a consistent and reproducible Jenkins deployment with Docker support. 