#!/bin/bash
# 마스터(컨트롤 노드)를 설정한다.

# sudo ip addr replace 192.168.56.110/24 brd 192.168.56.255 dev eth1
sudo ip addr replace 192.168.56.110/24 brd 192.168.56.255 dev eth1
sudo ifconfig eth1 broadcast 192.168.255.255

ip link set eth1 up

if curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1 --write-kubeconfig-mode 644" K3S_TOKEN=sejotoken sh -; then
    echo -e "K3s MASTER installation SUCCEEDED"
else
    echo -e "K3s MASTER installation FAILED"
fi

k3s="k3s"
ip route replace 192.168.56.0/24 dev eth1