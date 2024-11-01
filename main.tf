provider "docker" {}

resource "docker_network" "nginx_network" {
  name = "nginx_network"
}

resource "docker_container" "app" {
  name  = "details_app"
  image = "danors/details-app:latest"
  env   = { PORT = "5000" }
  networks_advanced {
    name = docker_network.nginx_network.name
  }
}

resource "docker_container" "nginx" {
  name  = "nginx_lb"
  image = "nginx:latest"
  ports {
    internal = 443
    external = 443
  }
  volumes {
    host_path      = "${path.module}/nginx/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }
  volumes {
    host_path      = "${path.module}/ssl"
    container_path = "/etc/nginx/ssl"
  }
  networks_advanced {
    name = docker_network.nginx_network.name
  }

  depends_on = [docker_container.app]
}

resource "local_file" "hosts_entry" {
  content = "${docker_container.nginx.ip_address} example.local"
  filename = "/etc/hosts"
}

output "nginx_ip" {
  value = docker_container.nginx.ip_address
}
