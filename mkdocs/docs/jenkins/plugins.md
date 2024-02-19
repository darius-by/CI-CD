# Docker, SSH Agent, and Prometheus Metrics Plugins

## Overview

This document provides an overview and technical details on integrating Docker Pipeline, SSH Agent Plugin, and Prometheus Metrics Plugin within a Jenkins pipeline. This integration enables the creation and use of Docker containers, secure SSH operations, and exporting build metrics for monitoring. Each plugin enhances the pipeline's capabilities, making it a powerful tool for continuous integration and delivery processes.

## Docker Pipeline

### Purpose

The Docker Pipeline plugin allows Jenkins pipelines to build, test, and deploy applications using Docker containers. This plugin offers a straightforward way to use Docker directly within a Jenkinsfile, providing a portable and consistent environment for application development.

### Example Usage

```groovy
pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("dariusby/the-house:${env.BUILD_ID}")
                }
            }
        }
    }
}
```

### Explanation

- `pipeline`: Defines a block for the entire pipeline.
- `agent any`: Specifies that the pipeline can run on any available agent.
- `stages`: Contains all stages of the pipeline.
- `stage('Build Docker Image')`: Defines a stage for building a Docker image.
- `steps`: Contains the steps to be executed in the current stage.
- `script`: Allows running Groovy scripts.
- `docker.build("dariusby/the-house:${env.BUILD_ID}")`: Uses the Docker Pipeline plugin to build a Docker image named "dariusby/the-house" with a tag corresponding to the Jenkins build ID.

### Expected Output

The output is a Docker image named "dariusby/the-house" tagged with the build ID, ready for further operations like testing or deployment.

## SSH Agent Plugin

### Purpose

The SSH Agent Plugin allows Jenkins pipelines to use SSH private keys securely. This is particularly useful for operations like checking out code, executing remote scripts, or accessing secure resources without hardcoding credentials.

### Example Usage

```groovy
pipeline {
    agent any
    environment {
        SSH_CREDENTIAL_ID = 'my-ssh-key'
    }
    stages {
        stage('Checkout Code') {
            steps {
                sshagent([SSH_CREDENTIAL_ID]) {
                    git 'ssh://git@example.com/my-repo.git'
                }
            }
        }
    }
}
```

### Explanation

- `environment`: Defines environment variables for the pipeline.
- `SSH_CREDENTIAL_ID`: An environment variable holding the ID of the SSH key added to Jenkins credentials.
- `sshagent([SSH_CREDENTIAL_ID])`: Starts the SSH Agent with the specified SSH key.
- `git 'ssh://git@example.com/my-repo.git'`: Uses the Git plugin to check out code using SSH.

### Expected Output

The output is the checked-out code from the specified Git repository, using SSH for secure access.

## Prometheus Metrics Plugin

### Purpose

The Prometheus Metrics Plugin exposes Jenkins metrics in a format compatible with Prometheus, a popular monitoring system. This enables real-time monitoring and analysis of Jenkins jobs, nodes, and overall system health.

### Example Usage

After installing the plugin, Prometheus can scrape Jenkins metrics at the `/prometheus` endpoint.

### Expected Output

Metrics are available in a format that Prometheus can scrape, providing insights into build durations, success rates, and system performance.

## Conclusion

Integrating Docker Pipeline, SSH Agent Plugin, and Prometheus Metrics Plugin into a Jenkins pipeline enhances its functionality significantly. Docker containers ensure consistent environments for building and testing applications. The SSH Agent Plugin secures operations requiring SSH access. Finally, the Prometheus Metrics Plugin offers valuable insights into the pipeline's performance, helping teams monitor and improve their CI/CD processes. Together, these plugins form a robust foundation for modern software development practices.