#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# ArgoCD 네임스페이스 생성
kubectl get ns argocd && echo "${RED}Namespace 'argocd' 이미 존재합니다.${RESET}" || kubectl create ns argocd
kubectl get ns dev && echo "${RED}Namespace 'dev' 이미 존재합니다.${RESET}" || kubectl create ns dev
echo "${GREEN}Namespace 'argocd'와 'dev' 생성 완료${RESET}"

# ArgoCD 설치
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml && \
echo "${RED}ArgoCD 이미 설치되어 있습니다.${RESET}" || echo "${GREEN}ArgoCD 설치 완료${RESET}"

# `wil42/playground` 배포를 위한 Kubernetes Deployment 생성
kubectl apply -f ./confs/deployment.yaml -n argocd
echo "${GREEN}'wil42/playground' 애플리케이션 배포 완료${RESET}"

# Argo CD CLI 설치하기
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
if which argocd >/dev/null 2>&1; then
    echo "${RED}ArgoCD CLI가 이미 설치되어 있습니다.${RESET}"
else
    sudo chmod +x /usr/local/bin/argocd
fi



# kubectl port-forward -n argocd svc/argocd-server 8080:443 -> 이런식으로 포트포워딩을 하면, 터미널에서 계속 실행 상태를 유지하며 포트를 포워딩한다
# 따라서 명령 끝에 &를 추가해야 함
: <<'END'
/dev/null과 &1은 리눅스에서 사용되는 특수한 파일 디스크립터입니다.
/dev/null은 특수한 파일로, 모든 데이터를 버릴 때 사용됩니다. 즉, /dev/null에 데이터를 쓰면 그 데이터는 사라집니다. 이를 통해 출력을 무시하거나, 프로세스에게 데이터를 보내지 않을 수 있습니다.
&1은 표준 출력(standard output)을 나타내는 파일 디스크립터입니다. 파일 디스크립터는 파일이나 입출력 장치와 연결된 번호입니다. &1은 표준 출력을 가리키는 특수한 파일 디스크립터입니다.
마지막 줄의 >/dev/null 2>&1은 리다이렉션(redirection)을 사용하여 출력을 /dev/null로 보내고, 표준 에러도 표준 출력으로 리다이렉션하는 것을 의미합니다. 이렇게 함으로써, 명령의 출력과 에러 메시지를 모두 무시할 수 있습니다.
간단히 말해, >/dev/null은 출력을 버리고, 2>&1은 표준 에러를 표준 출력으로 리다이렉션하여 모두 무시하는 것입니다. 이를 통해 명령이 실행되는 동안 출력과 에러 메시지를 터미널에 표시하지 않고, 백그라운드에서 실행할 수 있습니다.
END

# kubernetes secret에 저장되어있는 argoCD 비밀번호를 알 수 있는 스크립트 : kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode; echo

# ArgoCD 포트 포워딩
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
echo "ArgoCD is now accessible at http://localhost:8080"

# wil42/playground 포트 포워딩
kubectl port-forward svc/playground-service 8081:8888 -n dev > /dev/null 2>&1 &
echo "wil42/playground is now accessible at http://localhost:8081"

