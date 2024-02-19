# CAdvisor

This document outlines the process of deploying monitoring tools, specifically cAdvisor and Node Exporter, using Ansible for automation and Docker Compose for container orchestration. The deployment aims at setting up monitoring solutions on a host to track container metrics and system performance.

## Overview

Monitoring tools like cAdvisor and Node Exporter are essential for gaining insight into container and system metrics. cAdvisor provides container users an understanding of the resource usage and performance characteristics of their running containers. Node Exporter is a part of the Prometheus monitoring system, which allows monitoring of the host system's hardware and OS metrics exposed by *NIX kernels.

The deployment process involves two main steps:
1. Copying the Docker Compose file to the target host and setting appropriate permissions using Ansible.
2. Defining the services in the Docker Compose file, including configurations for cAdvisor and Node Exporter.

## Ansible Playbook

The Ansible playbook snippet provided below is responsible for copying the Docker Compose YAML file to a designated directory on the target host and setting its permissions.

```yaml
- name: Copy Docker compose file and set permissions
  ansible.builtin.copy:
    src: ./files/docker-compose.yaml
    dest: /home/ubuntu
    mode: '0755'
    owner: '1000'
    group: '1000'
```

### Explanation

- **src**: The source path of the Docker Compose file on the local machine.
- **dest**: The destination path on the target host where the Docker Compose file will be copied.
- **mode**: The permissions set for the file, in this case, `0755` (read and execute permissions for everyone, and write permission for the owner).
- **owner** and **group**: The user and group IDs for the file. `1000` is commonly used as the default non-root user ID.

## Docker Compose File

The Docker Compose file defines two services: `cadvisor` and `nodeexporter`, each configured to monitor different aspects of the host and containers.

### cAdvisor Service Configuration

```yaml
cadvisor:
  image: gcr.io/cadvisor/cadvisor-amd64:v0.47.2
  user: "1000:122"
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:rw
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
    - /dev/disk/:/dev/disk:ro
  ports:
    - "8081:8080"
  privileged: true
  restart: always
```

#### Explanation

- **image**: The Docker image to use, fetched from Google Container Registry.
- **user**: The user and group ID under which the cAdvisor container will run.
- **volumes**: Bind mounts for cAdvisor to monitor the host filesystem, Docker daemon, system metrics, and disk usage.
- **ports**: Maps port 8081 on the host to port 8080 on the container, where cAdvisor's web UI is accessible.
- **privileged**: Allows the container to access the host's resources fully.
- **restart**: Ensures the container always restarts unless stopped manually.

### Node Exporter Service Configuration

```yaml
nodeexporter:
  image: prom/node-exporter:v1.7.0
  volumes:
    - /proc:/host/proc:ro
    - /sys:/host/sys:ro
    - /:/rootfs:ro
  command:
    - '--path.procfs=/host/proc'
    - '--path.sysfs=/host/sys'
    - '--collector.filesystem.ignored-mount-points'
    - '^/(sys|proc|dev|host|etc)($$|/)'
  ports:
    - "9100:9100"
  restart: unless-stopped
```

#### Explanation

- **image**: Specifies the Docker image for Node Exporter.
- **volumes**: Mounts necessary for Node Exporter to collect hardware and OS metrics from the host.
- **command**: Custom command used to start Node Exporter with specific flags for procfs and sysfs paths and to ignore certain mount points.
- **ports**: Exposes Node Exporter on port 9100 of the host.
- **restart**: Configures the restart policy to avoid restarting automatically unless stopped.

## Conclusion

Deploying cAdvisor and Node Exporter using Ansible and Docker Compose automates the setup process, making it efficient and repeatable. This approach ensures monitoring tools are correctly configured and secured, providing valuable insights into container and system performance metrics. After deployment, users can access cAdvisor's web UI on port 8081 and Node Exporter's metrics on port 9100 of the host machine, enabling monitoring and analysis of the system and container health.