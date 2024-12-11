# Terraform NGINX SSL Proxy

A simple Terraform project that deploys two Docker containers: an NGINX SSL proxy and a "Hello World" application.

## What it does

- Creates an NGINX container with SSL configuration
- Creates an application container that responds with "Hello World"
- Sets up automatic DNS routing via hosts file
- Establishes secure communication between containers

## Project Structure

```
.
├── main.tf              # Main Terraform configuration
├── install.sh           # Dependencies installation script
├── nginx/
│   └── nginx.conf       # NGINX SSL and proxy configuration
└── ssl/                 # SSL certificates (generated during install)
```

## Quick Start

1. Install dependencies:

```bash
sudo ./install.sh
```

2. Deploy containers:

```bash
terraform init
terraform apply
```

3. Access the application:

```bash
# Add to /etc/hosts:
sudo sh -c "echo '127.0.0.1 example.local' >> /etc/hosts"

# Then visit:
https://example.local
```

4. Cleanup:

```bash
terraform destroy
```

## Documentation

- Project configuration: See comments in `main.tf`
- SSL configuration: See `nginx/nginx.conf`
- Installation details: See `install.sh`

## Additional Documentation

- [Detailed Installation Guide](INSTALL.md)
- [Project Tasks and Requirements](TASKS.md)
- [Project Contributors](CONTRIBUTIONS.md)
