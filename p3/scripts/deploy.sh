#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)

RESET=$(tput sgr0)

kubectl config use-context k3d-sejokimS

if ! kubectl get ns argocd > /dev/null 2>&1; then
    kubectl create ns argocd
    echo "${GREEN}Namespace 'argocd' 생성 완료${RESET}"
fi

if ! kubectl get ns dev > /dev/null 2>&1; then
    kubectl create ns dev
    echo "${GREEN}Namespace 'dev' 생성 완료${RESET}"
fi

if ! kubectl get -n argocd deployment argocd-server > /dev/null 2>&1; then
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    echo "${GREEN}ArgoCD 설치 완료${RESET}"
else
    echo "${RED}ArgoCD가 이미 설치되어 있습니다.${RESET}"
fi

kubectl apply -f ./confs/deployment.yaml
echo "${GREEN}ArgoCD + Git repository 연동 완료${RESET}"

if ! which argocd >/dev/null 2>&1; then
    sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo chmod +x /usr/local/bin/argocd
fi

kubectl port-forward svc/argocd-server -n argocd 8081:443 > /dev/null 2>&1 &
echo "${BLUE}이제 ArgoCD를 http://localhost:8081로 접근할 수 있습니다.${RESET}"


setup_port() {
    kubectl port-forward svc/service-sejokimapp 8888:8080 -n dev > /dev/null 2>&1 &
    PF_PID=$!
    echo "${GREEN}wil42/playground 앱이 http://localhost:8888에서 배포되고 있습니다.${RESET}"
}

# setup_port

wait_for_pods() {
    echo "${GREEN}파드가 모두 준비될 때까지 대기 중...${RESET}"
    kubectl wait --for=condition=Ready pod -l app=sejokimapp -n dev --timeout=60s
    echo "${BLUE}argoCD 기본 admin 계정 비밀번호 : $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)${RESET}"
}

get_initial_resource_version() {
  wait_for_pods
  LAST_HASH=$(kubectl get pod -n dev -l app=sejokimapp -o jsonpath='{.items[0].metadata.resourceVersion}')
}

watch_for_changes() {
  while true; do
    NEW_HASH=$(kubectl get pod -n dev -l app=sejokimapp -o jsonpath='{.items[0].metadata.resourceVersion}' 2>/dev/null)
    if [ "$NEW_HASH" != "$LAST_HASH" ]; then
      echo "${GREEN}파드 변화 감지됨. 포트 포워딩을 재시작합니다.${RESET}"
      kill $PF_PID
      wait_for_pods
      setup_port
      LAST_HASH=$NEW_HASH
    fi
    sleep 10
  done
}

setup_port
get_initial_resource_version
watch_for_changes
