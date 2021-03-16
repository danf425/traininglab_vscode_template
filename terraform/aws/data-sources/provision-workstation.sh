#!/bin/bash

set -eu -o pipefail

# Yum Update, Install Tree
# sudo yum clean all
sudo yum update --assumeyes --quiet

# # install docker
# curl -fsSL https://get.docker.com/ | sh
# echo "hi this is dan0"

# # Remove any old versions
# sudo yum remove docker docker-common docker-selinux docker-engine
# echo "hi this is dan"

# # Install required packages
# sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# echo "hi this is dan2"

# # Configure docker repository
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# echo "i made it this far 0"

# # Install Docker-ce
# sudo yum install docker-ce -y
# echo "i made it this far 00"

# # Start Docker
# sudo systemctl start docker
# sudo systemctl enable docker
# echo "i made it this far 000"
# # Post Installation Steps
# # Create Docker group
# sudo groupadd docker
# echo "i made it this far 1"


# Add nano editor
sudo yum install nano --assumeyes --quiet
echo "i made it this far 2"

# Install latest version of Chef Workstation
# curl -LO https://omnitruck.chef.io/install.sh && sudo bash ./install.sh -P chef-workstation && rm install.sh
# echo "i made it this far 3"


# Add Chef User in Wheel, Root & Docker Groups. No password for sudo
sudo useradd chef -G wheel,root
#,docker
echo "i made it this far 4"

sudo sh -c "echo 'chef ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers"
echo $1 | sudo passwd chef --stdin
sudo sed -i "/^PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo systemctl restart sshd.service
echo "i made it this far 5"
