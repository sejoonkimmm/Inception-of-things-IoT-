#!/bin/bash

# 마스터(컨트롤 노드)를 설정한다.

if export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san serverS --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "; then
    echo -e "export INSTALL_K3S_EXEC SUCCEEDED"
else
    echo -e "export INSTALL_K3S_EXEC FAILED"
fi

# Install master node
# https://docs.k3s.io/quick-start

if curl -sfL https://get.k3s.io | sh -; then
    echo -e "K3s MASTER installation SUCCEEDED"
else
    echo -e "K3s MASTER installation FAILED"
fi

# Copying the Vagrant token to the mounted folder, which will be necessary to install the worker
# https://docs.k3s.io/quick-start

if sudo cat /var/lib/rancher/k3s/server/token >> /vagrant/token.env; then
    echo -e "TOKEN SUCCESSFULLY SAVED$"
else
    echo -e "TOKEN SAVING FAILED$"
fi

# The command "sudo ip link" add eth1 type dummy creates a virtual network interface named eth1
# The command "sudo ip addr" add 192.168.56.110/24 dev eth1 assigns the IP address 192.168.56.110 with a subnet mask of /24
# The final part, sudo ip link set eth1 up, activates the eth1 interface.

if sudo ip link add eth1 type dummy && sudo ip addr add 192.168.56.110/24 dev eth1 && sudo ip link set eth1 up; then
    echo -e "add eth1 SUCCEESSFULLY$"
else
    echo -e "add eth1 FAILED$"
fi