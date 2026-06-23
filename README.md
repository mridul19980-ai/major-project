# Production Ready Three-Tier Web Application Deployment using DevOps Practices

An end-to-end cloud infrastructure implementation demonstrating the automation, orchestration, containerization, and monitoring of an agile 3-tier web architecture operating strictly within AWS Free Tier limitations.

## 🏗 Architecture Topology
[Presentation Layer: Nginx Frontend Pod] 
           │
           ▼ (Routed by Traefik Ingress Controller via /api Path)
[Application Layer: Node.js Backend API Pod]
           │
           ▼ (Targeted Cluster DNS Name: mysql)
[Database Layer: MySQL 8.4 Container Instance + Local Storage PV]

> Note: All workloads are explicitly scheduled to the Worker Node via Kubernetes Node Selectors to guarantee zero control plane degradation on the Master Node.

---

## 🛠 Tech Stack & Tools Integrated
* **Cloud Infrastructure:** AWS EC2 (2x `t2.micro`), AWS Custom VPC
* **Container Orchestration:** K3s Lightweight Kubernetes Distribution
* **Containerization Engine:** Docker & Engine Mechanics
* **CI/CD Orchestrator:** GitHub Actions Automation
* **Base Web Engine Stack:** Nginx UI, Node.js Engine, MySQL Database Engine
* **System Task Engineers:** Linux Bash Script Suite (Cron Execution)

---

## 🚀 Step-by-Step Cluster Deployment Sequence

### 1. Initialize Secrets and Data Contexts
Execute inside the K8s manifest control space:
2. Launch the Storage & Stateful Data Matrix
Bash
sudo kubectl apply -f k8s/mysql.yaml
3. Deploy App Components & Routing Pipelines
Bash
sudo kubectl apply -f k8s/backend.yaml
sudo kubectl apply -f k8s/frontend.yaml
sudo kubectl apply -f k8s/ingress.yaml
📊 Automation & Shell Crons Execution
System monitoring and scheduled local table extractions are governed via regular background jobs:

Plaintext
0 2 * * * /home/ubuntu/scripts/backup.sh
0 3 * * * /home/ubuntu/scripts/cleanup.sh
*/10 * * * * /home/ubuntu/scripts/monitor.sh

---

## **Part 4: Uploading to GitHub**

Once all your local files are populated, execute these terminal commands within your project root folder to link and push your workspace directly to your GitHub repository:

```bash
git init
git add .
git commit -m "feat: complete architectural 3-tier deployment with explicit worker node provisioning"
git branch -M main
git remote add origin https://github.com/mridul19980-ai/major-project.git
git push -u origin main --force
'''
