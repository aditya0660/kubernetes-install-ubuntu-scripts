#!/bin/bash

# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install Kubernetes components
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Initialize the master node
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Configure kubectl for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a pod network add-on (Calico in this example)
#kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
#kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# If you want to allow the master node to schedule pods, remove the taint
#kubectl taint nodes --all node-role.kubernetes.io/master-

# Join worker nodes to the cluster (run this on each worker node)
# Get the join command from the master node (you can run 'kubeadm token create --print-join-command' on the master)
# Replace <token> and <discovery-token-ca-cert-hash> with the values from the master
# Example command: sudo kubeadm join 192.168.0.100:6443 --token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890

