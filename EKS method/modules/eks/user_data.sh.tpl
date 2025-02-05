#!/bin/bash

# Install necessary packages (adjust for your AMI - Amazon Linux 2)
yum update -y
yum install -y kubelet kubeadm kubectl

# Join the cluster (using variables passed from Terraform)
JOIN_COMMAND=$(aws eks describe-cluster --name "${cluster_name}" --region "${region}" --query "cluster.resourcesVpcConfig.endpoint" --output text)

# Extract token and CA hash (you might need to fetch these dynamically)
TOKEN=$(aws eks describe-cluster --name "${cluster_name}" --region "${region}" --query "cluster.token" --output text)
CA_HASH=$(aws eks describe-cluster --name "${cluster_name}" --region "${region}" --query "cluster.certificateAuthority.data" --output text | base64 -d | openssl x509 -noout -fingerprint -sha256)
CA_HASH="${CA_HASH:9}" # Remove "SHA256=" prefix

kubeadm join "${JOIN_COMMAND}" --token "${TOKEN}" --discovery-token-ca-cert-hash sha256:"${CA_HASH}"

# Start the kubelet service
systemctl enable kubelet
systemctl start kubelet