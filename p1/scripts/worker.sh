#!/bin/bash

# sudo ip addr replace 192.168.56.111/24 brd 192.168.56.255 dev eth1
sudo ip addr replace 192.168.56.111/24 brd 192.168.56.255 dev eth1
sudo ifconfig eth1 broadcast 192.168.255.255
ip link set eth1 up


if curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 --token sejotoken --flannel-iface=eth1 --node-ip=192.168.56.111" sh -s; then
	echo -e "K3s WORKER installation SUCCEEDED"
else
	echo -e "K3s WORKER installation FAILED"
fi

k3s="k3s-agent"
ip route replace 192.168.56.0/24 dev eth1

# # The command "sudo ip link" add eth1 type dummy creates a virtual network interface named eth1
# # The command "sudo ip addr" add 192.168.56.111/24 dev eth1 assigns the IP address 192.168.56.111 with a subnet mask of /24
# # The final part, sudo ip link set eth1 up, activates the eth1 interface.

# if sudo ip link add eth1 type dummy && sudo ip addr add 192.168.56.111/24 dev eth1 && sudo ip link set eth1 up; then
# echo -e "add eth1 SUCCEESSFULLY"
# else
# echo -e "add eth1 FAILED"
# fi

# sudo rm /vagrant/token.env