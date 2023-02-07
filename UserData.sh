#!/bin/bash

#cweber@vmware.com 
#collection of commands meant to run in the UserData shell script for seting up an AWS EC2 instance from a Linux2 AMI
#Installs Git, Docker, Kubectl, Minikube, and helm and clones the VMBC Ethereum Dev Kit Beta repo
# In subsequent steps Minikube is configured as a Systemd service and then an AMI is created that runs helm install at boot 

sudo yum -y update
sudo yum -y install docker
sudo yum -y install git

sudo usermod -a -G docker ec2-user
id ec2-user
# Reload a Linux user's group assignments to docker w/o logout
newgrp docker

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubectl

#Start Docker and enable the systemd services to run at boot
sudo systemctl start docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

#Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
#helm version --short

helm repo add stable https://charts.helm.sh/stable/
helm repo update

git clone -b master https://github.com/vmware-samples/vmware-blockchain-samples.git eth-dev-kit

# After this runs the Minikube service needs to be created and the Helm install needs initiated. 
