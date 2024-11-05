# Project Installation Guide

This guide provides step-by-step instructions for setting up and running the Terraform-based multi-container Docker environment with NGINX as a load balancer.

## Repository

Clone the project repository from GitHub:

```bash
git clone https://github.com/DanorSODA/TerraForm-Single-File-Docker
cd TerraForm-Single-File-Docker
```

## Installation Steps

### Step 1: Run the Setup Script:

The project includes an install.sh script that automates dependency installation, SSL certificate generation, and Terraform initialization.

Run the script as root or with sudo:

```bash
sudo ./install.sh
```

This script performs the following:

1.Installs Docker: If Docker is not already installed, the script installs it.
2.Installs Docker Compose: Downloads and sets up Docker Compose if it's missing.
3.Installs Terraform: Adds HashiCorp's repository and installs Terraform.
4.Generates SSL Certificates: Creates an SSL certificate and key under the ssl/ directory for NGINX.
5.Initializes Terraform: Runs terraform init to initialize the environment.

### Step 2: Deploy the Environment with Terraform:

Once the setup completes, you can use Terraform to deploy the Docker environment.
This command will set up the NGINX and app containers, establish a Docker network, and apply SSL settings.

```bash
terraform apply
```

- Review the proposed changes and type yes to confirm the deployment.

After the deployment completes, Terraform will output the IP address of the NGINX container.

## Uninstallation

To remove the Docker containers and network, run:

```bash
terraform destroy
```

Confirm the action by typing yes.
This will stop and remove the containers, network, and any associated resources created by Terraform.
