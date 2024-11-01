#!/bin/bash

# Check if the script is run as root for installing software packages
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root or use sudo"
  exit
fi

# Function to check and install Docker
install_docker() {
  if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    apt update && apt install -y docker.io
    systemctl start docker
    systemctl enable docker
  else
    echo "Docker is already installed."
  fi
}

# Function to check and install Docker Compose
install_docker_compose() {
  if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K[0-9.]+')" \
    -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  else
    echo "Docker Compose is already installed."
  fi
}

# Function to check and install Terraform
install_terraform() {
  if ! command -v terraform &> /dev/null; then
    echo "Terraform not found. Installing Terraform..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt update && apt install -y terraform
  else
    echo "Terraform is already installed."
  fi
}

# Create SSL directory and generate certificates if they don't already exist
setup_ssl() {
  if [ ! -d "ssl" ]; then
    echo "Creating ssl directory and generating certificates..."
    mkdir -p ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl/key.pem -out ssl/cert.pem -subj "/CN=localhost"
  else
    echo "SSL directory and certificates already exist."
  fi
}

# Initialize Terraform
initialize_terraform() {
  echo "Initializing Terraform..."
  terraform init
}

# Run installation steps
install_docker
install_docker_compose
install_terraform
setup_ssl
initialize_terraform

echo "Installation and setup complete. You can now use Terraform to deploy your environment."
