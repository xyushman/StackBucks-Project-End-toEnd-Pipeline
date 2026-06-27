<div align="center">

# ☕ StackBucks — End-to-End DevSecOps Pipeline

### Deploying a Starbucks Clone Next.js App on Amazon EKS using a fully automated CI/CD pipeline with integrated security scanning and real-time monitoring.

<br/>

[![GitHub repo](https://img.shields.io/badge/GitHub-StackBucks--Pipeline-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/xyushman/StackBucks-Project-End-toEnd-Pipeline)
[![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![AWS EKS](https://img.shields.io/badge/Cloud-AWS%20EKS-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](https://aws.amazon.com/eks/)
[![SonarQube](https://img.shields.io/badge/Code%20Quality-SonarQube-4E9BCD?style=flat-square&logo=sonarqube&logoColor=white)](https://www.sonarsource.com/products/sonarqube/)
[![Trivy](https://img.shields.io/badge/Security-Trivy-00979D?style=flat-square&logo=trivy&logoColor=white)](https://trivy.dev/)
[![Prometheus](https://img.shields.io/badge/Monitoring-Prometheus-E6522C?style=flat-square&logo=prometheus&logoColor=white)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/Visualization-Grafana-F46800?style=flat-square&logo=grafana&logoColor=white)](https://grafana.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-623CE4?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io/)

</div>

---

## 📖 Overview

**StackBucks** is a production-grade **DevSecOps pipeline** project that deploys a Starbucks-clone Next.js application to an **Amazon EKS** cluster through a fully automated Jenkins CI/CD pipeline. The project integrates **security scanning at every stage** — from source code analysis with SonarQube to filesystem and container image vulnerability scanning with Trivy — and provides full observability via a Prometheus + Grafana monitoring stack.

This project demonstrates a real-world two-phase deployment strategy: first to a Docker container, then promoted to a Kubernetes cluster with monitoring, following modern DevSecOps best practices.

---

## 🏗️ Architecture

```
GitHub Push
    │
    ▼
Jenkins Pipeline
    │
    ├── 1. Clean Workspace
    ├── 2. Git Checkout
    ├── 3. SonarQube Static Analysis
    ├── 4. Quality Gate Check
    ├── 5. npm Install (Dependencies)
    ├── 6. Trivy Filesystem Scan
    ├── 7. Docker Build & Push (DockerHub)
    ├── 8. Trivy Image Scan
    └── 9. Deploy to Docker / EKS
              │
              ├── Phase 1 → Docker Container (port 3000)
              └── Phase 2 → Amazon EKS Cluster
                              │
                              ├── Prometheus (metrics collection)
                              └── Grafana (dashboards & visualization)
```

---

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| **Application** | Next.js, React, Tailwind CSS |
| **Version Control** | GitHub |
| **CI/CD** | Jenkins |
| **Containerization** | Docker |
| **Container Registry** | DockerHub |
| **Orchestration** | Kubernetes (Amazon EKS) |
| **Infrastructure as Code** | Terraform |
| **Static Analysis** | SonarQube |
| **Security Scanning** | Trivy (FS + Image scan) |
| **Security Best Practices** | OWASP |
| **Monitoring** | Prometheus |
| **Visualization** | Grafana |
| **Notifications** | Email (Jenkins `emailext`) |
| **Cloud Provider** | AWS (EC2, EKS, VPC, IAM) |

---

## 🚀 Project Phases

### Phase 1 — Containerized Deployment

The first phase of the pipeline builds and deploys the app as a Docker container on the Jenkins host:

- Source code is pulled from GitHub via a Jenkins webhook trigger
- SonarQube performs static code analysis and enforces a quality gate
- npm dependencies are installed and a Trivy filesystem scan is run on the source
- Docker image is built and pushed to DockerHub (`xyushman/starbucks:latest`)
- Trivy performs a vulnerability scan on the pushed image
- The container is deployed locally and exposed on **port 3000**
- Trivy scan reports (`trivyfs.txt`, `trivyimage.txt`) are emailed on every build

### Phase 2 — EKS Cluster Deployment with Monitoring

The second phase promotes the containerized app to a production-grade Kubernetes environment:

- Amazon EKS cluster provisioned via Terraform
- Kubernetes manifests applied from the `kubernetes/` directory (Deployment + Service)
- Prometheus deployed for real-time metrics collection from the cluster
- Grafana dashboards set up for infrastructure and application observability
- AWS Load Balancer exposes the app publicly via an EKS Service

---

## 📁 Repository Structure

```
StackBucks-Project-End-toEnd-Pipeline/
├── src/                    # Next.js application source
├── public/                 # Static assets
├── kubernetes/             # K8s Deployment and Service manifests
├── Scripts/                # Setup & helper shell scripts
├── Dockerfile              # Multi-stage Docker build
├── Jenkinsfile             # Declarative Jenkins pipeline
├── .dockerignore
├── package.json
├── tailwind.config.js
└── README.md
```

---

## 🔐 Jenkins Pipeline Stages

The `Jenkinsfile` defines the following declarative pipeline:
| 2 | **Checkout from Git** | Clones the `main` branch from GitHub |

| 3 | **SonarQube Analysis** | Runs static code analysis against the SonarQube server |

| 4 | **Quality Gate** | Waits for SonarQube quality gate result (non-blocking) |

| 5 | **Install Dependencies** | Runs `npm install` |

| 6 | **Trivy FS Scan** | Scans source filesystem for vulnerabilities → `trivyfs.txt` |
| 7 | **Docker Build & Push** | Builds and pushes `xyushman/starbucks:latest` to DockerHub |

| 8 | **Trivy Image Scan** | Scans the Docker image for CVEs → `trivyimage.txt` |
| 9 | **Deploy to Container** | Stops any existing container, runs fresh deployment on port 3000 |


**Post-build:** Sends an HTML email with build status and attaches both Trivy scan reports.


---


## ⚙️ Prerequisites

Before running this project, ensure the following are set up:


- **Jenkins** server with the following plugins and tools configured:

  - JDK (`jdk`), Node.js (`node`), SonarQube Scanner (`sonar-scanner`)
  - Docker plugin, Email Extension plugin

- **SonarQube** server running and accessible from Jenkins
- **Docker** installed on the Jenkins agent

- **Trivy** installed on the Jenkins agent
- **AWS CLI** configured with appropriate IAM permissions

- **kubectl** and **eksctl** installed for EKS management
- **Terraform** installed for infrastructure provisioning


### Jenkins Credentials Required


| Credential ID | Type | Purpose |

|---|---|---|
| `github-token` | Username/Password | GitHub repository access |

| `docker` | Username/Password | DockerHub push access |
| `Sonar-token` | Secret Text | SonarQube authentication |


---


## 🚦 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/xyushman/StackBucks-Project-End-toEnd-Pipeline
cd StackBucks-Project-End-toEnd-Pipeline
```

### 2. Configure Jenkins


# Provision EKS cluster via Terraform

# Verify deployment
kubectl get svc
```


### 5. Set Up Monitoring

```bash
# Install Prometheus and Grafana via Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack

# Port-forward Grafana (or use LoadBalancer service)
```

---

## 📊 Monitoring & Observability

| Tool | Purpose | Default Port |
|---|---|---|
| **Prometheus** | Scrapes metrics from Kubernetes nodes, pods, and app | 9090 |
| **Grafana** | Visualizes Prometheus metrics via dashboards | 3000 |

Recommended Grafana dashboards:
- **Kubernetes Cluster Overview** — Dashboard ID `6417`
- **Node Exporter Full** — Dashboard ID `1860`

kubectl port-forward svc/prometheus-grafana 3000:80
Access the app via the **LoadBalancer EXTERNAL-IP** printed by `kubectl get svc`.
---

kubectl get pods
## 🔒 Security Highlights
kubectl apply -f kubernetes/


- **SonarQube** performs SAST (Static Application Security Testing) on every commit
# Apply Kubernetes manifests
- **Trivy FS Scan** catches vulnerabilities in source code and dependencies before the image is built
terraform init && terraform apply
- **Trivy Image Scan** scans the final Docker image for OS-level and package CVEs before deployment
- **OWASP** guidelines followed for secure application configuration
cd Scripts/
- Scan reports are automatically attached to build notification emails for audit trails

```bash
### 4. Run Phase 2 (EKS Deployment)
---

- Add the required credentials (see table above)

## 📬 Build Notifications
```
http://<jenkins-server-ip>:3000

On every pipeline run (success or failure), an HTML email is sent to `ayushmanng04@gmail.com` containing:

- Build status and job name
```
- Attached `trivyfs.txt` and `trivyimage.txt` security scan reports

- Link to the Jenkins console output
Trigger the Jenkins pipeline. On success, the app will be running at:
---


### 3. Run Phase 1 (Docker Deployment)
- Set up a **GitHub webhook** to trigger builds on push

## 🐳 Docker

- Create a new **Pipeline** job pointing to this repo's `Jenkinsfile`
- Configure SonarQube server under **Manage Jenkins → Configure System**

```bash
# Pull and run the image directly

docker pull xyushman/starbucks:latest
docker run -d --name starbucks -p 3000:3000 xyushman/starbucks:latest
```

DockerHub: [`xyushman/starbucks`](https://hub.docker.com/r/xyushman/starbucks)


---


## 👤 Author


**Ayushman Nagar**
B.Tech AI — VIT Bhopal University


[![GitHub](https://img.shields.io/badge/GitHub-xyushman-181717?style=flat-square&logo=github)](https://github.com/xyushman)

[![Email](https://img.shields.io/badge/Email-ayushmanng04%40gmail.com-D14836?style=flat-square&logo=gmail&logoColor=white)](mailto:ayushmanng04@gmail.com)


---

<div align="center">


⭐ If this project helped you, consider giving it a star!


</div>
