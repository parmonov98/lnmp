#!/bin/bash
EXPECTED_ARGS=2
SERVER_USER=$1
SERVER_IP=$2
ssh-keygen -t rsa -b 4096 -f /home/dev/.ssh/$SERVER_USER -q -P ""
ssh $SERVER_USER@$SERVER_IP "mkdir -p /home/$SERVER_USER/.ssh/" 
    && scp -pr /home/dev/.ssh/$SERVER_NAME.pub $SERVER_USER@$SERVER_IP:/home/$SERVER_USER/.ssh/authorized_keys

echo "
Host $SERVER_USER
Hostname $SERVER_IP
User $SERVER_USER
IdentityFile ~/.ssh/
ServerAliveInterval 60
ServerAliveCountMax 120" >> /home/dev/.ssh/config

