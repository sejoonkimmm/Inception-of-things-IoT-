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

### Instruction

#### Part 1

Type 
```
vagrant up --provider=virtualbox
```

This command launches two virtual machines.
One serves as the master node and the other as a worker node. During the setup of the master node, a token provided as an option allows the worker node to connect to the master node.

and ssh login to Master node

```
vagrant ssh sejokimS
```

and Type this command

```
kubectl get nodes -o wide
```

<img width="1608" alt="image" src="https://github.com/sejoonkimmm/Inception-of-things-IoT-/assets/117820621/44e142e3-0298-408c-b78d-fee96d7c80ea">

K3s cluster setup is complete.


#### Part 2
Based on the requested host header, the traffic is routed to different domain names: sejokimapp1.com, sejokimapp2.com, and sejokimapp3.com.

You'll need to write the ingress, service, and deployment YAML files to configure Kubernetes.

**Ingress**
Ingress is an API object in Kubernetes that routes HTTP/HTTPS requests from outside the cluster to services within the cluster. It acts like a gateway, directing incoming requests to the appropriate services.

Here is an example of an Ingress configuration:

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
spec:
  rules:
  - host: sejokimapp1.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: app1-service
            port:
              number: 80
  - host: sejokimapp2.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: app2-service
            port:
              number: 80
  - host: sejokimapp3.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: app3-service
            port:
              number: 80
```
The metadata section includes information to identify and describe the Ingress object. The spec section defines the actual rules for routing traffic based on domain names to specific services.

**Deployment**
Deployment is used to declaratively update applications. It ensures that the specified number of Pods are running and recreates Pods as necessary to maintain the desired state.

Here's a brief on what Deployment looks like, although it’s a deep topic worthy of further exploration separately.

**Service**
Service defines a way to access Pods reliably within the internal network. It can act as a load balancer, distributing incoming requests to all Pods linked to the Service.

**YAML File**
All Kubernetes configuration files generally include three main sections:

metadata: Provides names and descriptions to distinguish components.
spec (specification): Applies detailed settings based on the type of component.
status: Automatically created and updated, it shows the desired and actual state, enabling Kubernetes' self-healing capabilities.
To create Pods, a Deployment is necessary, which maintains them reliably. Connecting a Service and a Deployment involves matching labels in the Deployment’s metadata with those specified in the Service's selector.

Here's a basic connection approach:
```
spec:
  selector:
    matchLabels:
      app: nginx
```
This matches with the Deployment where the app: nginx label is set, ensuring the Service routes traffic to the correct Pods.


<img width="1009" alt="Screen Shot 2024-04-23 at 5 26 10 PM" src="https://github.com/sejoonkimmm/Inception-of-things-IoT-/assets/117820621/5ce8e8ee-332f-4905-9ce6-a9a523d10a99">
<img width="1016" alt="Screen Shot 2024-04-23 at 5 25 32 PM" src="https://github.com/sejoonkimmm/Inception-of-things-IoT-/assets/117820621/0e3c61ee-7ded-43c6-a7e0-4bdee2378f29">
<img width="1011" alt="Screen Shot 2024-04-23 at 5 25 26 PM" src="https://github.com/sejoonkimmm/Inception-of-things-IoT-/assets/117820621/c989e806-b9cf-496d-a83f-475d4a414c49">
<img width="1007" alt="Screen Shot 2024-04-23 at 5 25 17 PM" src="https://github.com/sejoonkimmm/Inception-of-things-IoT-/assets/117820621/50d1e3f6-5fd0-4c66-8e4f-a045dc0d6967">

#### Part 3

Type

```
sh scripts/init_docker_k3d.sh
```

To install Docker, Kubernetes, and k3d and then create a k3d cluster

```
sh scripts/deploy.sh
```

To install Argo CD on a Kubernetes cluster and set it up so you can access it from localhost:8081, and to configure the admin password to be output to the terminal




https://github.com/sejoonkimmm/Inception-of-things-IoT-/assets/117820621/b0ee2d9b-08b3-48ca-b54b-c38a31705700








