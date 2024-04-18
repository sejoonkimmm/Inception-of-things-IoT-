#!/bin/bash


RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)

RESET=$(tput sgr0)

sudo ip addr replace 192.168.56.110/24 brd 192.168.56.255 dev eth1

ip link set eth1 up

if curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1 --write-kubeconfig-mode 644" K3S_TOKEN=sejotoken sh -; then
    echo -e "K3s MASTER installation SUCCEEDED"
else
    echo -e "K3s MASTER installation FAILED"
fi

k3s="k3s"
ip route replace 192.168.56.0/24 dev eth1

sudo service k3s restart

wait_for_k8s() {
    echo "{BLUE} 쿠버네티스가 시작할 때까지 기다리는 중입니다... ${RESET}"
    while ! kubectl get nodes &> /dev/null; do
        echo "${BLUE} API 대기중... ${RESET}"
        sleep 2
    done
    sleep 5
    echo "${GREEN} 쿠버네티스가 시작되었습니다. ${RESET}"
}

wait_for_k8s

echo "배포중입니다..."
sudo kubectl apply -f /vagrant/confs/app1.yaml --validate=false
sudo kubectl apply -f /vagrant/confs/app2.yaml --validate=false 
sudo kubectl apply -f /vagrant/confs/app3.yaml --validate=false
sudo kubectl apply -f /vagrant/confs/ingress.yaml --validate=false