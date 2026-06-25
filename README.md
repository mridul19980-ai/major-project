# End-to-End GitOps-Driven Kubernetes Pipeline

A robust, fully automated CI/CD pipeline and infrastructure-as-code project deploying a multi-tier microservices application. This repository provisions cloud infrastructure on AWS and utilizes GitHub Actions to continuously build, push, and deploy a containerized application (Frontend, Backend, and MySQL Database) to a lightweight K3s Kubernetes cluster.

## 🚀 Tech Stack & Tools

* **Cloud Provider:** AWS (EC2)
* **Containerization:** Docker & Docker Compose
* **Orchestration:** Kubernetes (K3s)
* **CI/CD:** GitHub Actions
* **Infrastructure as Code (IaC):** Terraform (`tf`)
* **Web Server / Reverse Proxy:** Nginx
* **Database:** MySQL
* **Version Control:** Git

## 📂 Repository Structure

```text
.
├── .github/workflows/
│   └── main.yml           # GitHub Actions CI/CD pipeline definition
├── K3s/                   # Kubernetes manifest files
│   ├── backend.yaml       # Backend Deployment & Service
│   ├── frontend.yaml      # Frontend Deployment (Nginx) & Service
│   ├── ingress.yaml       # Traefik Ingress routing rules
│   ├── mysql.yaml         # Stateful database Deployment & Service
│   └── secrets.yaml       # Encrypted credentials for the cluster
├── backend/               # Backend API source code and Dockerfile
├── database/              # Database initialization scripts and schemas
├── frontend/              # Frontend application source code and Dockerfile
├── infra(tf)/             # Terraform scripts for AWS EC2 provisioning
├── scripts/               # Automation and helper shell scripts
├── .env.example           # Template for local environment variables
├── .gitignore             # Ignored files and directories
├── docker-compose.yml     # Local testing and development orchestration
└── README.md              # Project documentation

```

## ⚙️ CI/CD Pipeline Workflow

The automated deployment pipeline is triggered on every push to the `main` branch. The GitHub Actions workflow executes the following steps:

1. **Code Checkout:** Pulls the latest source code.
2. **DockerHub Authentication:** Logs into DockerHub using repository secrets.
3. **Build & Push Images:** Builds the `frontend` and `backend` Docker images and pushes them to the DockerHub registry (e.g., `mridul19980/frontend:latest`).
4. **SSH into K3s Master:** Connects securely to the AWS EC2 instance hosting the K3s control plane.
5. **Deploy Manifests:** Applies the updated configuration files in the `K3s/` directory using `kubectl apply -f`.
6. **Rollout Verification:** Monitors the deployment status and waits for the new pods to reach the `Running` state before marking the pipeline as successful.

## 🛠️ Infrastructure Setup (Terraform)

The physical infrastructure is managed via Terraform. To provision the environment:

1. Navigate to the Terraform directory:
```bash

```



cd infra$tf$

```
2. Initialize the working directory:
   ```bash
terraform init

```

3. Review the infrastructure plan:
```bash

```



terraform plan

```
4. Provision the AWS EC2 resources:
   ```bash
terraform apply --auto-approve

```

## 🚢 Kubernetes Deployment (K3s)

The application utilizes K3s for lightweight container orchestration.

### Key Configurations:

* **Resource Limits:** Implemented strict CPU and Memory boundaries (e.g., `512Mi` limits for frontend pods) to prevent node resource exhaustion.
* **Networking:** Internal communication is handled via Kubernetes `ClusterIP` Services mapping to designated pods (e.g., `backend` service resolving on port `5000`).
* **Ingress:** Traefik routes external traffic from the node's public IP directly to the `frontend-service` on port `80`.

### Manual Deployment

If bypassing the CI/CD pipeline for testing, apply the cluster manifests manually:

```bash
kubectl apply -f K3s/secrets.yaml
kubectl apply -f K3s/mysql.yaml
kubectl apply -f K3s/backend.yaml
kubectl apply -f K3s/frontend.yaml
kubectl apply -f K3s/ingress.yaml

```

## 💻 Local Development

To run the entire application stack locally without Kubernetes, utilize Docker Compose:

```bash
# Start all services in detached mode
docker-compose up -d

# View application logs
docker-compose logs -f

# Tear down the local environment
docker-compose down

```

## 🔒 Prerequisites & Secrets

To successfully fork and run this project, configure the following **GitHub Repository Secrets**:

* `DOCKERHUB_USERNAME`
* `DOCKERHUB_TOKEN`
* `EC2_SSH_KEY` (Private key for SSH access to the K3s node)
* `EC2_HOST` (Public IP of the AWS instance)
* `EC2_USER` (Default is usually `ubuntu` or `ec2-user`)

---

*Developed by Mridul Choudhary*

<img width="1920" height="1080" alt="Screenshot 2026-06-25 122626" src="https://github.com/user-attachments/assets/bba3e63a-861a-4ed5-bd03-d964ce4dd192" />
fig 

<img width="1920" height="1080" alt="Screenshot 2026-06-25 122601" src="https://github.com/user-attachments/assets/6669f82c-409c-46dd-89ad-90745cf21f5b" />
fig 

<img width="1920" height="1080" alt="Screenshot 2026-06-25 122514" src="https://github.com/user-attachments/assets/43af766c-8baf-4b81-af63-a798beb7b0ce" />
fig 

<img width="1920" height="1080" alt="Screenshot 2026-06-25 122455" src="https://github.com/user-attachments/assets/98f8bf3a-04b5-4d84-ad4b-ff5762e7586c" />
fig 

<img width="1920" height="1080" alt="Screenshot 2026-06-25 122438" src="https://github.com/user-attachments/assets/456ea4ba-0f5b-44e0-b87c-f33413366dd7" />
fig 

<img width="1920" height="1080" alt="Screenshot 2026-06-25 121735" src="https://github.com/user-attachments/assets/4f646db8-7e7a-45e1-9140-d3e6cd26099b" />
fig 

<img width="1920" height="1080" alt="Screenshot 2026-06-25 120951" src="https://github.com/user-attachments/assets/fb5aab02-68d9-4a2d-9188-f39f276dd417" />
fig 

<img width="1920" height="1080" alt="Screenshot 2026-06-25 120933" src="https://github.com/user-attachments/assets/e5e64fb2-b249-4189-ad74-37b11f448f1e" />
fig 

