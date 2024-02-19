# Docker System Config

### Overview

The Ansible playbook snippets provided here are designed to perform three key actions: create a Docker group, add a user to the Docker group, and enable and start Docker services. This automation enhances the scalability and repeatability of Docker deployments across various environments.

### Code Snippets and Descriptions

#### 1. Add Docker Group

```yaml
- name: Add Docker group
  ansible.builtin.group:
    name: docker
    state: present
```

**Description**: This task ensures the presence of a group named "docker" on the target system. If the group does not exist, Ansible will create it.

**Expected Output**: A group called "docker" is created on the target system. If the group already exists, the task will not make any changes.

#### 2. Add User to Docker Group

```yaml
- name: Add user to Docker group
  ansible.builtin.user:
    name: "{{ ansible_user }}"
    groups: docker
    append: true
```

**Description**: This task adds the specified user (in this case, the user executing the Ansible playbook, denoted by `{{ ansible_user }}`) to the "docker" group. The `append: true` parameter ensures that the user is added to the "docker" group without removing them from any other groups they belong to.

**Expected Output**: The executing user is added to the "docker" group. This membership allows the user to execute Docker commands without needing superuser privileges.

#### 3. Enable and Start Docker Services

```yaml
- name: Enable and start Docker services
  ansible.builtin.systemd:
    name: "{{ item }}"
    enabled: true
    state: started
  loop:
    - docker.service
    - containerd.service
```

**Description**: This task iterates over a list of Docker-related services (`docker.service` and `containerd.service`) and ensures that each service is enabled (to start at boot) and started immediately. This automation is crucial for maintaining the services' operational state across reboots.

**Expected Output**: Both `docker.service` and `containerd.service` are enabled and running on the target system. This ensures that Docker is ready to manage containers immediately after setup or a system reboot.

### Conclusion

The provided Ansible playbook snippets offer a streamlined method for integrating Docker into your DevOps pipeline. By automating the setup process, you minimize manual intervention, reduce the potential for human error, and ensure a consistent environment for Docker deployments. Through tasks like adding the Docker group, including users in this group, and managing service states, Ansible facilitates a more efficient and reliable container management system.