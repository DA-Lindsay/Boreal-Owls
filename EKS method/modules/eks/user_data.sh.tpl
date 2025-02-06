#!/bin/bash

set -o xtrace

# Install AWS CLI & necessary tools
yum update -y
yum install -y aws-cli jq

# Fetch the cluster name from Terraform
export CLUSTER_NAME="spelling-app-cluster" 
export REGION="eu-west-2"


# Install SSM Agent (optional, for troubleshooting)
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install & start kubelet
yum install -y kubelet kubeadm kubectl
systemctl enable kubelet
systemctl start kubelet

# Fetch and run the Amazon EKS Bootstrap script
/etc/eks/bootstrap.sh "$CLUSTER_NAME"

# Restart kubelet (ensure it picks up config changes)
systemctl restart kubelet
