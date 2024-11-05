# Specify the required providers and their versions for this Terraform project.
# Using "kreuzwerker/docker" as the official Docker provider.
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

# Initialize the Docker provider.
provider "docker" {}

# Define a Docker network for inter-container communication.
resource "docker_network" "nginx_network" {
  name = "nginx_network"  # Name of the Docker bridge network
}

# Define the application container that will respond with "hello world".
resource "docker_container" "app" {
  name  = "details_app"  # Name of the container
  image = "danors/details-app:latest"  # Docker image to use for the app
  env   = ["PORT=5000"]  # Set environment variable for the app
  networks_advanced {
    name = docker_network.nginx_network.name  # Connect to the custom Docker network
  }
}

# Define the NGINX container with SSL, acting as a reverse proxy for the app container.
resource "docker_container" "nginx" {
  name  = "nginx_lb"  # Name of the NGINX container
  image = "nginx:latest"  # Docker image to use for NGINX
  
  # Expose port 443 for HTTPS connections
  ports {
    internal = 443
    external = 443
  }
  
  # Mount NGINX configuration file from host to container
  volumes {
    host_path      = abspath("${path.module}/nginx/nginx.conf")
    container_path = "/etc/nginx/nginx.conf"
  }
  
  # Mount SSL certificates from host to container
  volumes {
    host_path      = abspath("${path.module}/ssl")
    container_path = "/etc/nginx/ssl"
  }
  
  # Connect to the custom Docker network for inter-container communication
  networks_advanced {
    name = docker_network.nginx_network.name
  }
  
  # Set up dependency to ensure the app container is running first
  depends_on = [docker_container.app]

  # Command to keep NGINX in the foreground, required for Docker containers to stay active
  command = ["nginx", "-g", "daemon off;"]
}

# Local file resource to simulate DNS by mapping NGINX IP to a domain.
# Using a local file instead of /etc/hosts to avoid permission issues.
resource "local_file" "hosts_entry" {
  content  = "${docker_container.nginx.network_data[0].ip_address} example.local"  # Add NGINX IP with a fake domain
  filename = "${path.module}/hosts_override"  # Output file to store the entry
}

# Output the NGINX container's IP address after deployment.
output "nginx_ip" {
  value = docker_container.nginx.network_data[0].ip_address
}
