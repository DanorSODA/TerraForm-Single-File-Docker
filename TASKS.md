# Project Tasks and Implementation Details

## Task List

### 1. Project Setup and Environment Initialization

- **Define File Structure**: Created a clear and organized file structure to manage Terraform and NGINX configurations.

### 2. Define and Configure Docker Services

- **NGINX as Load Balancer**:

  - Configured NGINX to act as a load balancer and reverse proxy, forwarding incoming HTTPS requests to an application container.
  - Set up NGINX to listen on port 443 with SSL, using self-signed certificates.
  - Created an NGINX configuration file (`nginx.conf`) under `nginx/` to specify SSL and reverse proxy settings.

- **App Container**:
  - Configured a simple app container using an available Docker image (`danors/details-app`)
  - Exposed port 5000 to allow internal communication from NGINX.
  - Linked the app container to the Docker network for seamless communication with NGINX.

### 3. Infrastructure as Code (Terraform)

- **Write Terraform Configuration** (`main.tf`):

  - Defined `docker_network` to enable inter-container communication.
  - Defined `docker_container` resources for both NGINX and app containers.
  - Configured volume mounts for NGINX SSL certificates and configuration files.
  - Added dependency management to ensure the app container starts before NGINX.
  - Implemented an `output` block to display the NGINX IP address upon deployment.

- **DNS Simulation**:
  - Used a `local_file` resource to create a `hosts_override` file, mapping the NGINX IP to a domain (`example.local`).
  - Documented how to use this file for local testing by appending to `/etc/hosts`.

### 4. SSL Configuration

- **Certificate Generation**:
  - Created an automated SSL setup within `install.sh` to generate self-signed certificates.
  - Placed generated certificates in the `ssl/` directory for secure access by NGINX.

### 5. Automation with `install.sh`

- **Install Dependencies**:

  - Added automated checks and installation for Docker and Terraform based on the detected Linux distribution.
  - Implemented `detect_package_manager` to switch between `apt` (for Debian-based) and `yum` (for Red Hat-based) systems.
  - Ensured necessary permissions and user context when running Terraform commands.

- **Initialize Terraform**:
  - Automated the `terraform init` step to set up necessary providers and modules.
  - Verified dependencies, including Docker and Terraform, to prevent environment issues.
