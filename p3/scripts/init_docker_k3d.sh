RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

if ! [ -x "$(command -v docker)" ]; then
  echo "${RED}도커 설치 중...${RESET}"
  curl -s https://get.docker.com/ | sudo sh
  echo "${GREEN}도커 권한 설정 중${RESET}"
  sudo usermod -aG docker $USER
  newgrp docker
else
  echo "${GREEN}Docker는 이미 설치되어 있습니다.${RESET}"
  docker --version
fi

if ! [ -x "$(command -v k3d)" ]; then
  echo "${RED}k3d 설치 중...${RESET}"
  wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
  echo "${GREEN}k3d는 이미 설치되어 있습니다.${RESET}"
  k3d version
fi

if ! [ -x "$(command -v kubectl)" ]; then
  echo "${RED}kubectl 설치 중...${RESET}"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
  echo "${GREEN}kubectl은 이미 설치되어 있습니다.${RESET}"
  kubectl version --client
fi

# Check if k3d cluster exists
if ! k3d cluster list | grep -q "sejokimS"; then
  echo "${RED}sejokimS라는 이름의 k3d cluster를 생성 중...${RESET}"
  k3d cluster create sejokimS
else
  echo "${GREEN}sejokimS라는 이름의 k3d cluster가 이미 존재합니다.${RESET}"
  k3d cluster list
fi

