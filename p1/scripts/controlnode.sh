#!/bin/bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

echo "Waiting for k3s to start..."

cat /var/lib/rancher/k3s/server/node-token > /vagrant/k3s_token