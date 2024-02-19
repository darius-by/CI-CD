# Docker Compose

## Overview

This documentation provides a detailed guide for DevOps engineers on how to automate the deployment of Docker Compose applications using Ansible. The process involves two primary tasks: launching Docker Compose and displaying the status of the execution. This guide includes code snippets, expected outputs, and a thorough explanation of each component involved in the tasks.

## Task Descriptions

### Launch Docker Compose

This task automates the deployment of a Docker Compose application on a target machine using Ansible. The provided code snippet executes a Docker Compose file, resulting in the creation and starting of all services defined within the Docker Compose configuration file.

**Code Snippet:**

```yaml
- name: Launch Docker Compose
  ansible.builtin.shell:
    cmd: docker compose -f /home/ubuntu/docker-compose.yaml up -d
    chdir: /home/ubuntu
  register: output
```

**Components:**

- `ansible.builtin.shell`: This module executes commands in nodes. It is used here to run Docker Compose.
- `cmd`: Specifies the command to execute. Here, `docker compose -f /home/ubuntu/docker-compose.yaml up -d` launches Docker Compose in detached mode (`-d`), using the compose file located at `/home/ubuntu/docker-compose.yaml`.
- `chdir`: Changes the current directory to the specified path (`/home/ubuntu`) before executing the command.
- `register`: Captures the output of the command execution into the variable named `output`.

**Expected Output:**

The command does not produce a visible output to Ansible directly because it runs in detached mode. However, the `output` variable captures execution details, including success status and any error messages.

### Show Status

Following the execution of the Docker Compose command, this task displays the output captured by the `register` directive in the previous step. This is useful for debugging and confirming the execution status of the Docker Compose deployment.

**Code Snippet:**

```yaml
- name: Show status
  ansible.builtin.debug:
    var: output
```

**Components:**

- `ansible.builtin.debug`: This module prints statements during execution, used here to display the content of the `output` variable.
- `var`: Specifies the variable name (`output`) whose contents are to be displayed.

**Expected Output:**

The output will include execution details such as whether the command was successfully executed, any error messages, and other command execution metadata. The exact content depends on the command's execution and Docker Compose's response.

## Conclusion

This guide has detailed the automation of Docker Compose deployment using Ansible. The process not only automates the deployment but also aids in monitoring and debugging by capturing and displaying the execution status.