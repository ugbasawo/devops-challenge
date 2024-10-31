# Use the official Nginx image from Docker Hub as the base image
FROM nginx:alpine

# Copy the static website files into the Nginx default public directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 90

# install bash into the container 
#lightweight images usually do not have bash installed
RUN apk add --no-cache bash

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
