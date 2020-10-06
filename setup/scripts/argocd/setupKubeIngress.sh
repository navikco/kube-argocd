#!/bin/bash

set -e

if [[ $# -eq 1 ]]
then

    ENVIRONMENT=${1}
    echo "ENVIRONMENT :::>>> ${ENVIRONMENT}"

else
    echo "Usage: . ./kube-land-ingress.sh <<ENVIRONMENT>>"
    exit 1
fi

cd ../../cluster/argocd/ingress/

echo "CREATING :::>>> K8S Ingress Controller for EWS ::: [[[ ${ENVIRONMENT} ]]]..."

kubectl apply -f kube-ingress-controller.yml

sleep 20

kubectl apply -f kube-ingress-service.yml

kubectl patch deployments -n ingress-nginx nginx-ingress-controller -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx-ingress-controller","ports":[{"containerPort":80,"hostPort":80},{"containerPort":443,"hostPort":443}]}],"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'

echo "CREATED :::>>> K8S Ingress Controller for EWS ::: [[[ ${ENVIRONMENT} ]]]..."

exit 0
