# Use the official Nginx image as the base image
FROM nginx:alpine

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Copy the current directory contents (HTML, CSS, JS) into the container
COPY . .

# Expose port 80 to the host
EXPOSE 80

# The default Nginx configuration serves files from /usr/share/nginx/html
# No CMD instruction is needed as the Nginx base image already specifies the default command
