# Grafana & Prometheus

This documentation provides a detailed guide for DevOps engineers on automating the deployment of a monitoring solution using Ansible, Grafana, and Prometheus. The guide includes code snippets for Ansible playbooks and configurations for Docker Compose, along with explanations of their purpose and expected outputs.

## Overview

The goal is to automate the deployment of a Docker-based monitoring stack that includes Grafana for visualization and Prometheus for metrics collection. The automation is achieved using Ansible.

## Ansible Playbook Snippets

The Ansible playbook snippets below are designed to copy configuration files to a target server and set the appropriate permissions. These files include a Docker Compose file, a Grafana environment configuration file, and a Prometheus configuration file.

### Copy Docker Compose File and Set Permissions

```yaml
- name: Copy Docker compose file and set permissions
  ansible.builtin.copy:
    src: ./files/docker-compose.yaml
    dest: /home/ubuntu
    mode: '0755'
    owner: '1000'
    group: '1000'
```

**Explanation:** This task copies the `docker-compose.yaml` file from the local directory `./files` to `/home/ubuntu` on the target machine. It sets the file permissions to `0755` (readable and executable by everyone but writable only by the owner), and assigns ownership to user and group with ID `1000`.

### Copy env File and Set Permissions

```yaml
- name: Copy env file and set permissions
  ansible.builtin.copy:
    src: ./files/grafana.env
    dest: /home/ubuntu
    mode: '0755'
    owner: '1000'
    group: '1000'
```

**Explanation:** Similar to the Docker Compose file, this task copies the `grafana.env` file, ensuring it has the correct permissions and ownership for the Grafana service to read its environment variables.

### Copy Prometheus Configuration File and Set Permissions

```yaml
- name: Copy prometheus file and set permissions
  ansible.builtin.copy:
    src: ./files/prometheus.yml
    dest: /home/ubuntu
    mode: '0755'
    owner: '1000'
    group: '1000'
```

**Explanation:** This task copies the `prometheus.yml` configuration file for Prometheus, setting the appropriate permissions and ownership to allow Prometheus to access its configuration.

## Docker Compose File

The Docker Compose file orchestrates the deployment of Grafana and Prometheus services, including volume management for data persistence.

```yaml
version: '3.8'

services:
  grafana:
    image: grafana/grafana:latest
    volumes:
      - grafana_data:/var/lib/grafana
    env_file:
      - grafana.env
    ports:
      - "3000:3000"
    restart: unless-stopped

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - prometheus_data:/prometheus
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    restart: unless-stopped

volumes:
  grafana_data:
  prometheus_data:
```

**Explanation:** This configuration starts two services, Grafana and Prometheus, each with its dedicated volumes for data storage. Grafana is accessible on port 3000, and Prometheus on port 9090. The services are configured to restart automatically unless manually stopped.

## Prometheus Configuration File (`prometheus.yml`)

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'jenkins-data'
    static_configs:
      - targets: ['13.48.223.124:8080']
    metrics_path: '/prometheus'

  - job_name: 'the-room-cadvisor'
    static_configs:
      - targets: ['51.20.13.144:8081']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['51.20.13.144:9100']
    metrics_path: '/metrics'
```

**Explanation:** The Prometheus configuration specifies how often to scrape metrics (`scrape_interval: 15s`) and defines multiple jobs for collecting metrics from various sources. These sources include Prometheus itself, a Jenkins instance, a cAdvisor instance, and a node exporter, each identified by its job name and target address.

## Conclusion

By automating the deployment of Grafana and Prometheus with Ansible, DevOps engineers can efficiently manage monitoring solutions across multiple environments. This guide has provided the necessary steps and configurations to set up a basic monitoring stack, ensuring that services are deployed with the correct configurations and permissions for secure and reliable operation.