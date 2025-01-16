#!/bin/bash
# Update the package index
sudo apt-get update

# Install prerequisite packages
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker's official APT repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the package index again
sudo apt-get update

# Install Docker CE
sudo apt-get install -y docker-ce

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker
