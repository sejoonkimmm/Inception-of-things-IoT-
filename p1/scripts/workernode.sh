#!/bin/bash

while [ ! -f /vagrant/k3s_token ]; do sleep 1; done

K3S_TOKEN=$(cat /vagrant/k3s_token)

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${K3S_TOKEN} sh -