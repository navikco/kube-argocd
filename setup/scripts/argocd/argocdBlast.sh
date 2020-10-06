#!/bin/bash

set -e

if [[ $# -eq 1 ]]
then

    BREED=${1}
    echo ${BREED}

else
    echo "Usage: . ./argocdBlast.sh <<BREED>>"
    exit 1
fi

#################
#INSTALL ARGO-CD#
#################

echo "INSTALL :::>>> ArgoCD..."

kubectl create -f ../../cluster/argocd/kube-cd.yml

echo "INSTALLED :::>>> ArgoCD..."

sleep 30

##########
#START UP#
##########

./setupKubeLandDeployment.sh ${BREED} admin nobuild

./setupKubeLandDeployment.sh ${BREED} accounts nobuild

./setupKubeLandDeployment.sh ${BREED} customers nobuild

./setupKubeLandDeployment.sh ${BREED} users nobuild

sleep 10

kubectl port-forward service/argocd-server 5000:80 --namespace=kube-cd &

argocd login localhost:5000 --username admin --password p@ss10n --insecure --grpc-web;

argocd repo add git@github.com:navikco/kube-argocd.git --insecure-skip-server-verification --name kube-${BREED} --ssh-private-key-path ~/.ssh/id_rsa

argocd proj create kube --description "Kube-Ingress-ArgoCD Ecosystem" --dest "https://kubernetes.default.svc","*" --src "*" --orphaned-resources
argocd proj allow-cluster-resource kube "*" "*"
#argocd proj allow-namespace-resource kube "*" "*"

#argocd app create embs-${BREED} --repo ssh://git@bitbucket.dal.securustech.net:7999/mid/kube-${BREED}.git --revision "master" --path cluster/embs/ --project kube --dest-server "https://kubernetes.default.svc" --dest-namespace embs-${BREED} --directory-recurse

#sleep 45

argocd app create kube-${BREED} --repo git@github.com:navikco/kube-argocd.git --revision "master" --path setup/cluster/kube-${BREED}/ --project kube --dest-server "https://kubernetes.default.svc" --dest-namespace kube-${BREED}  --sync-policy automated --directory-recurse --self-heal --auto-prune

sleep 30

exit 0
