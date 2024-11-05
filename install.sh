#!/bin/bash

# Check if the script is run as root for installing software packages
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root or use sudo"
  exit 1
fi

# Function to identify the package manager based on the OS distribution
detect_package_manager() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" =~ (debian|ubuntu) ]]; then
      PACKAGE_MANAGER="apt"
    elif [[ "$ID" =~ (centos|rhel|fedora) ]]; then
      PACKAGE_MANAGER="yum"
    else
      echo "Unsupported distribution: $ID"
      exit 1
    fi
  else
    echo "/etc/os-release not found. Unable to detect the operating system."
    exit 1
  fi
}

# Function to check and install Docker
install_docker() {
  if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    $PACKAGE_MANAGER update -y
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
      $PACKAGE_MANAGER install -y docker.io
    else
      $PACKAGE_MANAGER install -y docker
    fi
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
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com focal main" | tee /etc/apt/sources.list.d/hashicorp.list
      $PACKAGE_MANAGER update && $PACKAGE_MANAGER install -y terraform
    else
      yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
      $PACKAGE_MANAGER install -y terraform
    fi
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
    chmod -R 644 ssl/*  # Set permissions for SSL files
  else
    echo "SSL directory and certificates already exist."
  fi
}

# Initialize Terraform in the user context
initialize_terraform() {
  echo "Initializing Terraform..."
  sudo -u "$SUDO_USER" terraform init || { echo "Terraform initialization failed"; exit 1; }
}

# Detect package manager and run installation steps
detect_package_manager
install_docker
install_docker_compose
install_terraform
setup_ssl
initialize_terraform

echo "Installation and setup complete. You can now use Terraform to deploy your environment."
