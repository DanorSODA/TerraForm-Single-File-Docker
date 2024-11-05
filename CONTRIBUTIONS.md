# Project Contributions

This file outlines the main contributions of each team member for the Terraform and Docker multi-container project.

## Team Members

- **Danor Sinai**
- **Yossi Avni**

## Contributions

### Danor Sinai

- **Project Setup**: Structured the project files and created main documentation (`README.md`).
- **Docker & NGINX Config**: Set up `nginx` as a load balancer with HTTPS, configured `app` container, and created `docker-compose.yaml`.
- **Terraform Setup**: Wrote core Terraform configuration in `main.tf`, defined Docker resources, and output NGINX IP.

### Yossi Avni

- **Install Script**: Developed `install.sh` for automated dependency installation with OS detection (Debian/Red Hat).
- **SSL Automation**: Added SSL certificate generation in `install.sh` and integrated it with NGINX.
- **Terraform Config Enhancements**: Managed dependencies, mounted volumes for SSL, and documented Terraform resources.
- **Additional Documentation**: Wrote `install.md`, `tasks.md`, and contributed to `CONTRIBUTIONS.md`.
