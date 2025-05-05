#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Updating package lists..."
sudo apt-get update

echo "Installing Docker..."
sudo apt install docker.io -y

echo "Adjusting Docker socket permissions..."
sudo chmod 666 /var/run/docker.sock

echo "Installing dependencies for Kubernetes repo..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

echo "Creating directory for Kubernetes keyring..."
sudo mkdir -p -m 755 /etc/apt/keyrings

echo "Adding Kubernetes signing key..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Adding Kubernetes apt repository..."
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | \
    sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package lists after adding Kubernetes repo..."
sudo apt update

echo "Installing kubeadm, kubelet, and kubectl version 1.30.0-1.1..."
sudo apt install -y kubeadm=1.30.0-1.1 kubelet=1.30.0-1.1 kubectl=1.30.0-1.1

echo "Kubernetes and Docker setup complete."
