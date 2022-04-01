#!/bin/bash
EXPECTED_ARGS=2
SERVER_USER=$1
SERVER_IP=$2
ssh-keygen -t rsa -b 4096 -f /home/$SERVER_USER/.ssh/$SERVER_USER -q -P ""
ssh $SERVER_USER@$SERVER_IP "mkdir -p /home/$SERVER_USER/.ssh/" 
    && scp -pr /home/$SERVER_USER/.ssh/$SERVER_NAME.pub $SERVER_USER@$SERVER_IP:/home/$SERVER_USER/.ssh/authorized_keys
