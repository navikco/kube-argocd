#!/bin/bash

set -e

if [[ $# -eq 1 ]]
then

    ENVIRONMENT=${1}
    echo ${ENVIRONMENT}

else
    echo "Usage: . ./argocdBlast.sh <<ENVIRONMENT>>"
    exit 1
fi

#################
#INSTALL ARGO-CD#
#################

echo "INSTALL :::>>> ArgoCD..."

kubectl create -f ../../cluster/argocd/kube-cd.yml

echo "INSTALLED :::>>> ArgoCD..."

sleep 130

##########
#START UP#
##########

kubectl port-forward service/argocd-server 5000:80 --namespace=kube-cd &
sleep 10

argocd login localhost:5000 --username admin --password p@ss10n --insecure --grpc-web;

argocd repo add git@github.com:navikco/kube-argocd.git --insecure-skip-server-verification --name kube-${ENVIRONMENT} --ssh-private-key-path ~/.ssh/id_rsa

argocd proj create kube-apps --description "Kube-Ingress-ArgoCD Ecosystem" --dest "https://kubernetes.default.svc","*" --src "*" --orphaned-resources
argocd proj allow-cluster-resource kube-apps "*" "*"

argocd app create kube-${ENVIRONMENT} --repo git@github.com:navikco/kube-argocd.git --revision "master" --path setup/cluster/kube-${ENVIRONMENT}/ --project kube-apps --dest-server "https://kubernetes.default.svc" --dest-namespace kube-${ENVIRONMENT}  --sync-policy automated --directory-recurse --self-heal --auto-prune

argocd proj create kube-tektoncd --description "Kube-Ingress-TektonCD Ecosystem" --dest "https://kubernetes.default.svc","*" --src "*" --orphaned-resources
argocd proj allow-cluster-resource kube-tektoncd "*" "*"

argocd app create kube-tektoncd-${ENVIRONMENT} --repo git@github.com:navikco/kube-argocd.git --revision "master" --path setup/cluster/tektoncd/ --project kube-tektoncd --dest-server "https://kubernetes.default.svc" --dest-namespace kube-${ENVIRONMENT}  --sync-policy automated --directory-recurse --self-heal --auto-prune

sleep 30

kubectl port-forward service/tekton-dashboard 5005:9097 --namespace=kube-tekton-cd &
sleep 10

exit 0
