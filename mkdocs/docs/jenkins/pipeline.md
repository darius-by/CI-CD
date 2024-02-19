## Overview

The given Jenkins pipeline script is designed for a DevOps engineer to automate the Continuous Integration/Continuous Deployment (CI/CD) process. This process includes building a Docker image from the source code, pushing the image to Docker Hub, deploying the image to an Amazon EC2 instance, and performing a health check on the deployed application. This pipeline is structured to run on any agent, using defined environment variables for credentials and deployment targets, ensuring a secure and dynamic setup.

## Pipeline Structure and Code Explanation

### Environment Variables

The `environment` block defines several key variables used throughout the pipeline:

- `DOCKERHUB_CREDENTIALS_ID`: The ID for Docker Hub credentials, used to authenticate with Docker Hub.
- `SSH_CREDENTIALS_ID`: The ID for SSH credentials, used for secure shell access to the EC2 instance.
- `DEPLOY_HOST`: The SSH address of the EC2 instance where the application will be deployed.
- `APP_MAIN_URL`: The main URL of the application, used for the health check.

### Stages

#### Build

```groovy
stage('Build') {
    steps {
        script {
            dockerImage = docker.build("dariusby/the-house:${env.BUILD_ID}")
        }
    }
}
```

This stage builds a Docker image from the source code using the Docker Pipeline plugin. The image is tagged with the build ID, ensuring a unique identifier for each build.

#### Push to Docker Hub

```groovy
stage('Push to Docker Hub') {
    steps {
        script {
            docker.withRegistry('', DOCKERHUB_CREDENTIALS_ID) {
                dockerImage.push("${env.BUILD_ID}")
                dockerImage.push("latest")
            }
        }
    }
}
```

After building the image, this stage logs into Docker Hub using the credentials ID and pushes the newly built image. It updates both the build-specific tag and the `latest` tag, ensuring that `latest` always points to the most recent build.

#### Deploy to EC2

```groovy
stage('Deploy to EC2') {
    steps {
        script {
            sshagent([SSH_CREDENTIALS_ID]) {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_HOST} '
                        echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin
                        docker pull dariusby/the-house:${env.BUILD_ID}
                        docker stop the-house-game || true
                        docker rm the-house-game || true
                        docker run -d --name the-house-game -p 8080:8080 dariusby/the-house:${env.BUILD_ID}
                    '
                    """
                }
            }
        }
    }
}
```

This stage uses SSH to connect to the EC2 instance and deploy the Docker image. It stops any previously running container of the application, removes it, and then runs a new instance of the container with the newly built image.

#### Health Check

```groovy
stage('Health Check') {
    steps {
        script {
            sh """
            echo "Checking if the app's main page is up..."
            response=\$(curl --write-out '%{http_code}' --silent --output /dev/null ${APP_MAIN_URL})
            if [ "\$response" -eq 200 ] ; then
                echo "App's main page is up and responding with HTTP 200!"
            else
                echo "App's main page is not responding as expected. Response code: \$response"
                exit 1
            fi
            """
        }
    }
}
```

The final stage performs a health check by making an HTTP request to the application's main URL. It checks for an HTTP 200 response code, indicating that the application is up and running. If the response is not 200, the pipeline fails, signaling an issue with the deployment.

## Conclusion

This Jenkins pipeline automates the deployment process, ensuring that new versions of the application are built, pushed to Docker Hub, deployed to an EC2 instance, and verified automatically. By utilizing environment variables for sensitive information and structuring the pipeline into clear stages, it provides a secure, maintainable, and efficient CI/CD workflow.