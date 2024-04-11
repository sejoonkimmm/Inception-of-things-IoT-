#!/bin/bash

# /etc/hosts 파일 수정
echo "Updating /etc/hosts file..."
if sudo bash -c 'echo -e "192.168.56.110 sejokimapp1.com\n192.168.56.110 sejokimapp2.com\n192.168.56.110 sejokimapp3.com" >> /etc/hosts'; then
    echo "/etc/hosts file update SUCCEEDED"
else
    echo "/etc/hosts file update FAILED"
    exit 1
fi