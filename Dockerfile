# Stage 1: Build Docker
FROM docker:20.10.7 AS docker-build

# Install necessary packages (if needed)
RUN apk add --no-cache \
   bash \
   curl \
   git \
   && rm -rf /var/cache/apk/*

# Stage 2: Build Jenkins
FROM jenkins/jenkins:lts AS jenkins-build

# Switch to root to install Docker
USER root

# Install Docker in the Jenkins image
RUN apt-get update && \
   apt-get install -y \
   apt-transport-https \
   ca-certificates \
   curl \
   gnupg2 \
   software-properties-common && \
   curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
   add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable" && \
   apt-get update && \
   apt-get install -y docker-ce docker-ce-cli && \
   usermod -aG docker jenkins

# Switch back to jenkins user
USER jenkins

EXPOSE 8080

# Stage 3: Final Image
FROM nginx:alpine

# Copy application files from the current directory into the image
COPY . /usr/share/nginx/html

# Copy Docker from the docker-build stage
COPY --from=docker-build /usr/local/bin/docker /usr/local/bin/docker

# Copy Jenkins home directory from the jenkins-build stage
COPY --from=jenkins-build /var/jenkins_home /var/jenkins_home

# Set environment variables
ENV DOCKER_HOST=unix:///var/run/docker.sock

# Expose port 80 for Nginx
EXPOSE 90

# Start Nginx (default command)
CMD ["nginx", "-g", "daemon off;"]