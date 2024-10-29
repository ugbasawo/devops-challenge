
terraform {
   required_providers { 
      docker = {
         source = "kreuzwerker/docker"
         version = "3.0.2"
      }
   }
}

provider "docker" {
  #location where docker is listening on locally.
  host = "unix:///var/run/docker.sock" #
}


resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_volume" "nginx_volume" {
   name = "nginx_data"
}

resource "docker_network" "nginx_network" {
   name = "nginx_bridge"
}
resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "nginx-container"

  ports {
    internal = 80 #port inside the container
    external = 8000 #port outside the container
  }
  
  networks_advanced {
   name = docker_network.nginx_network.name
  }

    // Use volume_name to reference the Docker volume
  mounts {
    target = "/usr/share/nginx/html"
    source = docker_volume.nginx_volume.name
    type   = "volume"
  }
}

