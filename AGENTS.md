# Homelab Agents

This repository contains the configuration for my Homelab, managed using Docker, Kubernetes, and Ansible.

## Repository Structure

The repository is organized as follows:

-   `.github/workflows/`: Contains GitHub Actions workflows for Continuous Integration and Continuous Deployment (CI/CD).
-   `docker/`: Contains services running as Docker containers, defined with Docker Compose.
-   `infraestructure/`: Contains Infrastructure as Code configurations using Ansible.
-   `kubernetes/`: Contains manifest files and configurations for the Kubernetes cluster.

## Docker Services

Services running in Docker are located in the `docker/` folder. Each subdirectory corresponds to a service and contains a `compose.yml` file for deployment with Docker Compose.

Current services include:
- emby
- homeassistant
- homebridge
- transmission
- doco-cd (deploys the others)

### Automatic Deployment

The services run on the tower and are deployed by [doco-cd](https://doco.cd), with no CI runner on the host. doco-cd polls this repo (`main`) and applies the stacks listed in `.doco-cd.yml`. With `force_image_pull`, it also redeploys a service when its image tag points to a new digest in the registry.

doco-cd itself is installed by `infraestructure/tower.yml`, not by doco-cd. To add a service, create `docker/<service>/compose.yml` and add an entry to `.doco-cd.yml`.

## Kubernetes Cluster

The `kubernetes/` folder is intended to contain Kubernetes manifests for applications deployed in the cluster.

The configuration and provisioning of the k3s cluster are performed using Ansible, and the playbooks are located in `infraestructure/k3s/`.

## Infrastructure Management with Ansible

The `infraestructure/` folder contains everything necessary to manage the infrastructure with Ansible.

-   `ansible.cfg`: Ansible configuration file.
-   `inventory/hosts`: Ansible inventory with the definition of the hosts that compose the infrastructure.
-   `update.yml`: Ansible playbook for updating the systems.
-   `tower.yml`: Prepares the tower (Docker on boot, Tailscale, media dir, ufw) and installs doco-cd. Run with `-K`.
-   `k3s/`: Playbooks for the deployment and configuration of a k3s cluster.
    -   `main.yml`: Main playbook that orchestrates the installation.
    -   `master.yml`: Playbook for configuring master nodes.
    -   `worker.yml`: Playbook for configuring worker nodes.