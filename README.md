# DevOps Assignment – CI/CD, Docker, Terraform, and AWS

---

## Project Overview

This repository contains a full DevOps workflow for deploying a Java-based Spring Boot application to an AWS EC2 instance using Docker containers and infrastructure provisioning with Terraform. The system implements a CI/CD pipeline using GitHub Actions for automation.

---

## Why GitHub Actions Instead of Jenkins?

The initial plan included Jenkins for CI/CD, but due to resource limitations on a `t2.micro` instance (AWS free tier), the decision was made to switch to GitHub Actions. GitHub-hosted runners provide better performance without additional cost, allowing the pipeline to complete builds and deployments efficiently.

---

## CI/CD Pipeline

### Trigger:

The workflow is triggered only when specific files are updated on the `main` branch:

* `src/**`
* `Dockerfile`
* `pom.xml`

### Workflow Steps:

1. Clone the repository
2. Set up Java 17 environment (Temurin distribution)
3. Run unit tests with Maven
4. Build Docker image
5. Login to Docker Hub using GitHub Secrets
6. Push the image to Docker Hub
7. SSH into the EC2 instance
8. Stop and remove any previous container named `deployment-demo`
9. Pull and run the new Docker container (internally on port 8080, mapped to host's port 80, 80:8080)

The workflow file is located at `.github/workflows/deploy.yml`

---

## Docker Overview

* The image is built using a multi-stage build with Alpine-based base images for minimal size.

* The container exposes port `8080`, mapped to `80` on the host.

* The image is automatically built and pushed to a public Docker Hub repository as part of the CI/CD workflow.

* If you fork this repository or use it as a template, make sure to update the Docker Hub credentials and image name accordingly in the workflow and Terraform configuration.

---

## Terraform Infrastructure

Terraform provisions the following:

* An Ubuntu 22.04 EC2 instance

* Security Group with inbound ports: 22 (SSH), 80 (HTTP)

* Installs Docker

* Adds the `ubuntu` user to the `docker` group, allowing GitHub Actions to run Docker commands without requiring `sudo`. This is essential for CI/CD automation over SSH (The reason for the reboot at the end).

* Runs the container on instance start via `user_data`

  * The container is launched using the `--restart unless-stopped` flag, which ensures it automatically restarts after an EC2 reboot. This improves reliability by avoiding the need for manual restarts in case the instance goes down and comes back up.

* To apply the infrastructure:

```bash
cd terraform
terraform init
terraform apply
```

---

## Public Access

Once deployed, the application is accessible at:

```
http://<EC2_PUBLIC_IP>:80/hello
```

---

## GitHub Actions Workflow

File: `.github/workflows/deploy.yml`

---

## GitHub Secrets Configuration

Before running the pipeline, define the following secrets under your repository:

| Name              | Description                         |
| ----------------- | ----------------------------------- |
| `DOCKER_USERNAME` | Docker Hub username                 |
| `DOCKER_PASSWORD` | Docker Hub password or access token |
| `EC2_USER`        | EC2 username, usually `ubuntu`      |
| `EC2_HOST`        | EC2 public IP address               |
| `EC2_KEY`         | SSH private key in base64 format    |

To encode your `.pem` file:

```bash
base64 -w 0 ec2-key.pem > ec2-key.txt
```

Paste the content of `ec2-key.txt` into the `EC2_KEY` secret.

---

## How to Run

1. Clone this repository:

   ```bash
   git clone https://github.com/IZ1KG/Dev-deployment.git
   cd Dev-deployment
   ```

2. Provision infrastructure:

   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

3. Push changes to `main` branch (only in `src/**`, `Dockerfile`, or `pom.xml`) to trigger the pipeline.

---

## Additional Notes

* The pipeline ensures only one instance of the container (`deployment-demo`) is running at all times.
* The container uses `--restart unless-stopped` to automatically recover from reboots.
* The Docker image used in Terraform is public, so no credentials are needed for `docker pull` on EC2.
