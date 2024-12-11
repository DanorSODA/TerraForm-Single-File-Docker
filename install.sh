#!/usr/bin/env bash

# Set strict bash mode
set -euo pipefail
IFS=$'\n\t'

# Bash-specific safety settings
shopt -s nullglob
shopt -s failglob
shopt -s inherit_errexit

# Root check - consistent with root-only approach
if [ "$(id -u)" -ne 0 ]; then 
    echo "This script must be run as root (not using sudo)"
    exit 1
fi

# Function to identify the package manager using bash-specific syntax
detect_package_manager() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ "$ID" =~ ^(debian|ubuntu)$ ]]; then
            PACKAGE_MANAGER="apt"
        elif [[ "$ID" =~ ^(centos|rhel|fedora)$ ]]; then
            PACKAGE_MANAGER="dnf"
        else
            echo "Unsupported distribution: $ID"
            exit 1
        fi
    else
        echo "Cannot detect OS distribution"
        exit 1
    fi
}

# Install Docker using official repository and modern packages
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
            # Remove any potential conflicting packages
            apt-get remove -y docker docker-engine docker.io containerd runc || true
            
            # Add Docker's official GPG key
            apt-get update
            apt-get install -y ca-certificates curl gnupg
            install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            chmod a+r /etc/apt/keyrings/docker.gpg
            
            # Add the repository to Apt sources
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker packages
            apt-get update
            apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        elif [[ "$PACKAGE_MANAGER" == "dnf" ]]; then
            dnf -y install dnf-plugins-core
            dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        fi
        
        # Start and enable Docker service
        systemctl start docker
        systemctl enable docker
    else
        echo "Docker is already installed"
    fi
}

# Install Terraform using official HashiCorp repository
install_terraform() {
    if ! command -v terraform &> /dev/null; then
        echo "Installing Terraform..."
        if [[ "$PACKAGE_MANAGER" == "apt" ]]; then
            wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
            apt-get update && apt-get install -y terraform
        else
            dnf install -y yum-utils
            yum-config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
            dnf install -y terraform
        fi
    else
        echo "Terraform is already installed"
    fi
}

# Setup SSL certificates
setup_ssl() {
    if [[ ! -d "ssl" ]]; then
        mkdir -p ssl
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout ssl/key.pem -out ssl/cert.pem \
            -subj "/CN=localhost"
        chmod 600 ssl/*.pem
    fi
}

# Main execution
main() {
    detect_package_manager
    install_docker
    install_terraform
    setup_ssl
    echo "Setup complete"
}

main