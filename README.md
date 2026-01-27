# 🏠 Homelab - Infrastructure as Code

Infrastructure repository for a hybrid homelab with a Raspberry Pi cluster and x86_64 tower, managed via GitOps and CI/CD.

![Homelab Diagram](architecture.drawio.svg)

## 📁 Repository Structure

```
homelab/
├── docker/                    # Services with Docker Compose
│   ├── emby/                 # Media server
│   ├── pihole/               # DNS ad-blocker  
|   ├── service...
├── kubernetes/               # Kubernetes manifests
│   ├── apps/                # Applications deployed on K8s
│   │   └── whoami/         # Example application
│   ├── argocd/             # ArgoCD configuration
│   │   ├── applications/   # Application definitions
│   │   ├── root-app.yaml  # Main App of Apps
│   │   ├── project.yaml   # ArgoCD project
│   │   └── install.sh     # Installation script
│   ├── base/              # Common base resources
│   └── kustomization.yaml # Root kustomization
├── infrastructure/        # Ansible playbooks and inventory
│   ├── inventory/ # Hosts and vars
│   ├── playbooks/  # Ansible playbooks
│   └── workflow.yml # Ansible playbook workflow 
└── .github/
    └── workflows/        # CI/CD workflows
        └── deploy-docker.yml

```

## 🎯 Homelab Architecture

### Hardware
- **Main Tower (x86_64)**: Heavy services (Emby, Plex, etc.)
- **6x Raspberry Pi**: Distributed services (Pi-hole, automation, etc.)

### Deployment Strategy
- **Docker Compose**: Services with GitHub Actions
- **Kubernetes (K3s)**: Services with GitOps (ArgoCD)
