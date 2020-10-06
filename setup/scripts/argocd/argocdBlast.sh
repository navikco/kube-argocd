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

#kubectl create -f ../../cluster/kube-cd.yml

echo "INSTALLED :::>>> ArgoCD..."

#sleep 30

##########
#START UP#
##########

./setupKubeLandDeployment.sh ${BREED} admin

./setupKubeLandDeployment.sh ${BREED} accounts

./setupKubeLandDeployment.sh ${BREED} customers

./setupKubeLandDeployment.sh ${BREED} users

sleep 30

kubectl port-forward service/argocd-server 5000:80 --namespace=kube-cd &

argocd login localhost:5000 --username admin --password p@ss10n --insecure --grpc-web;

argocd repo add ssh://git@bitbucket.dal.securustech.net:7999/mid/config-${BREED}.git --insecure-skip-server-verification --enable-lfs --name config-${BREED} --ssh-private-key-path ~/.ssh/id_rsa

argocd proj create kube --description "Kube-Ingress-ArgoCD Ecosystem" --dest "https://kubernetes.default.svc","*" --src "*" --orphaned-resources
argocd proj allow-cluster-resource kube "*" "*"
#argocd proj allow-namespace-resource kube "*" "*"

#argocd app create embs-${BREED} --repo ssh://git@bitbucket.dal.securustech.net:7999/mid/config-${BREED}.git --revision "master" --path cluster/embs/ --project kube --dest-server "https://kubernetes.default.svc" --dest-namespace embs-${BREED} --directory-recurse

#sleep 45

argocd app create kube-${BREED} --repo ssh://git@bitbucket.dal.securustech.net:7999/mid/config-${BREED}.git --revision "master" --path cluster/kube/ --project kube --dest-server "https://kubernetes.default.svc" --dest-namespace kube-${BREED} --directory-recurse

argocd app sync --local argocd/config-${BREED}/kube/ kube-${BREED}

sleep 30

exit 0
