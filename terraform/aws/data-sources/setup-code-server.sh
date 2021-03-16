#!/bin/bash


# Prep for Code-Server Install
sudo yum update --assumeyes
curl -sL https://rpm.nodesource.com/setup_13.x | sudo bash -
sudo yum install nodejs --assumeyes
sudo yum groupinstall 'Development Tools' --assumeyes
sudo yum install python2 libsecret-devel libX11-devel libxkbfile-devel --assumeyes
npm config set python python2


# Add repo and update git to v2
sudo yum install -y https://repo.ius.io/ius-release-el7.rpm
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y yum-plugin-replace
sudo yum replace -y git --replace-with git224



# Download and install Code Server
sudo npm install -g --unsafe-perm code-server



# Install Code Server service
sudo mv /tmp/code-server.service /etc/systemd/system/code-server.service

# Provision Settings file for code server
sudo mkdir -p /home/chef/.local/share/code-server/User
sudo mkdir -p /home/chef/.config/code-server
sudo mv /tmp/code-server-settings.json /home/chef/.local/share/code-server/User/settings.json
sudo mv /tmp/config.yaml /home/chef/.config/code-server/config.yaml
sudo chown -R chef:chef /home/chef/.local
sudo chown -R chef:chef /home/chef/.config



# Enable Code Server
sudo systemctl daemon-reload
sudo systemctl start code-server
sudo systemctl enable code-server


# rebuild rpm and yum database
sudo rpm --rebuilddb
sudo yum clean all

