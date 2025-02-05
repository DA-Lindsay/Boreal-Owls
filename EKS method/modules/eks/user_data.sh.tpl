#!/bin/bash

# Install necessary packages (adjust for your AMI - Amazon Linux 2)
yum update -y
yum install -y kubelet kubeadm kubectl gettext

# Join the cluster (using variables passed from Terraform and substituted by envsubst)
JOIN_COMMAND=$(aws eks describe-cluster --name "${CLUSTER_NAME}" --region "${region}" --query "cluster.resourcesVpcConfig.endpoint" --output text)

TOKEN=$(aws eks describe-cluster --name "${CLUSTER_NAME}" --region "${region}" --query "cluster.token" --output text)

CA_HASH=$(aws eks describe-cluster --name "${CLUSTER_NAME}" --region "${region}" --query "cluster.certificateAuthority.data" --output text | base64 -d | openssl x509 -noout -fingerprint -sha256)

# Remove "SHA256=" prefix correctly
CA_HASH="$${CA_HASH#SHA256=}"

export CLUSTER_NAME="$${CLUSTER_NAME}"
export region="$${region}"

kubeadm join "$${JOIN_COMMAND}" --token "$${TOKEN}" --discovery-token-ca-cert-hash sha256:"$${CA_HASH}"

# Start the kubelet service
systemctl enable kubelet
systemctl start kubelet