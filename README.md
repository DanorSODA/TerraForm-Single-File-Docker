# Terraform Multi-Container Docker Environment with NGINX Load Balancer

This project sets up a multi-container Docker environment using Terraform, with NGINX configured as a load balancer that forwards requests to an application container of details app. The setup includes HTTPS with SSL configuration for secure communication.

## Project Overview

- **NGINX as Load Balancer**: Configured to route incoming HTTPS traffic to an app container over a Docker network.
- **App Container**: the details app container.
- **Infrastructure as Code**: The environment is defined using Terraform and Docker, ensuring consistent setup across different environments.

## Prerequisites

### Software Requirements
The following software will be installed automatically if not found:
- Docker: Container runtime to run NGINX and app containers.
- Docker Compose: (Optional) For managing containers locally using Docker Compose.
- Terraform: Infrastructure-as-Code tool to provision the Docker environment.

## File Structure

```plaintext
.
├── main.tf                  # Terraform configuration file for multi-container setup
├── install.sh               # Script for setting up dependencies and initializing the environment
├── docker-compose.yaml      # Docker Compose file for local multi-container environment
├── nginx/
│   └── nginx.conf           # NGINX configuration file for SSL and load balancing
├── ssl/                     # Directory for generated SSL certificates (created automatically by `install.sh`)
├── README.md                # Project documentation (this file)
├── install.md               # Detailed installation steps and usage
├── tasks.md                 # Task list and project requirements
└── contributors.md          # List of contributors to the project
```


- [Installation guide](INSTALL.md)
- [Contributing](CONTRIBUTIONS.md)
- [Tasks file](TASKS.md)
