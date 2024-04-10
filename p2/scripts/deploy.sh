#!/bin/bash

if export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san serverS --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "; then
    echo -e "export INSTALL_K3S_EXEC SUCCEEDED"
else
    echo -e "export INSTALL_K3S_EXEC FAILED"
fi

if curl -sfL https://get.k3s.io | sh -; then
    echo -e "K3s MASTER installation SUCCEEDED"
else
    echo -e "K3s MASTER installation FAILED"
fi

echo "배포중입니다..."
kubectl apply -f /vagrant/confs/app1.yaml
kubectl apply -f /vagrant/confs/app2.yaml
kubectl apply -f /vagrant/confs/app3.yaml
kubectl apply -f /vagrant/confs/ingress.yaml
