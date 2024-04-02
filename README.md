# Inception-of-things-IoT-
42Seoul Outer-circle Project

<img width="561" alt="image" src="https://github.com/sejoonkimmm/Inception-of-things-IoT-/assets/117820621/509a0a98-e25e-456a-a8e9-75fbf6debcdb">

# Project Title: Inception-of-Things (IoT)

## General

This project aims to provide a hands-on experience with Kubernetes, using K3s, K3d, and Argo CD. It is structured into three mandatory parts and an optional bonus part, focusing on setting up and deploying web applications in a Kubernetes environment.

## General Guidelines

The project must be completed in a virtual machine.
Configuration files should be placed in root directories: p1, p2, p3, and bonus for the bonus part.
It is recommended to read extensively on K8s, K3s, and K3d for a comprehensive understanding.


## Project Setup
### Prerequisites
VirtualBox or any preferred VM provider.
Vagrant for virtual machine management.
Docker for containerization.
Kubectl for interacting with the Kubernetes cluster.

### Installation
Virtual Machine Setup: Use Vagrant to set up two virtual machines. Refer to the Vagrantfile examples provided for configuration details.
K3s Installation: Install K3s on both VMs, configuring one as a server and the other as an agent.
K3d and Argo CD: Install K3d on your host machine and set up Argo CD for continuous integration.

### Usage
#### Part 1: K3s and Vagrant
Initialize two VMs with Vagrant, setting up K3s with the server-agent model.
#### Part 2: K3s and Three Simple Applications
Deploy three web applications accessible via different hostnames, using K3s on a single VM.
#### Part 3: K3d and Argo CD
Transition to a K3d environment, implementing CI/CD with Argo CD for automated deployment from a GitHub repository.
#### Bonus Part
Integrate GitLab into your setup, configuring it to work with your Kubernetes cluster for an enhanced CI/CD pipeline.
