FROM jenkins/jenkins:lts
USER root

RUN apt-get update -qq \
 && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Add Docker's stable repository
RUN add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Install Docker and Docker Compose
RUN apt-get update -qq \
 && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# Add Jenkins user to the Docker group
RUN usermod -aG docker jenkins

# Add Jenkins user to the 'dockerhost' group if it exists (skip if it already exists)
RUN getent group dockerhost || true && usermod -aG dockerhost jenkins || true

# Change Jenkins user and group ID to 1000
RUN usermod -u 1000 jenkins && groupmod -g 1000 jenkins


USER jenkins
