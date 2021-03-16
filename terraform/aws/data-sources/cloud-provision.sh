#!/bin/bash

# Enable Password SSH
echo "i made it this far 20"

sudo sed -i "s/^\(ssh_pwauth:[[:space:]]*\)0/\11/" /etc/cloud/cloud.cfg
