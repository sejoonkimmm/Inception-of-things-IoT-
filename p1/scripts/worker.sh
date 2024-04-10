#!/bin/bash


if export INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 -t $(cat /vagrant/token.env) --node-ip=192.168.56.111"; then
        echo -e "export INSTALL_K3S_EXEC SUCCEEDED"
else
        echo -e "export INSTALL_K3S_EXEC FAILED"
fi

# workernode를 설정한다.

if curl -sfL https://get.k3s.io | sh -; then
	echo -e "K3s WORKER installation SUCCEEDED"
else
	echo -e "K3s WORKER installation FAILED"
fi

# The command "sudo ip link" add eth1 type dummy creates a virtual network interface named eth1
# The command "sudo ip addr" add 192.168.56.111/24 dev eth1 assigns the IP address 192.168.56.111 with a subnet mask of /24
# The final part, sudo ip link set eth1 up, activates the eth1 interface.

if sudo ip link add eth1 type dummy && sudo ip addr add 192.168.56.111/24 dev eth1 && sudo ip link set eth1 up; then
echo -e "add eth1 SUCCEESSFULLY"
else
echo -e "add eth1 FAILED"
fi

sudo rm /vagrant/token.env