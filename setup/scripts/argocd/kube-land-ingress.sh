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

cd ../../cluster/ingress/

echo "CREATING :::>>> K8S Ingress Controller for EWS ::: [[[ ${ENVIRONMENT} ]]]..."

#docker pull quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0
#docker tag quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0 localhost:5000/quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0
#docker push localhost:5000/quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.30.0

#kubectl apply -f kube-ingress-nginx.yml

#kubectl apply -f kube-ingress-config.yml

kubectl apply -f kube-ingress-controller.yml

sleep 20

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/baremetal/service-nodeport.yaml
kubectl apply -f kube-ingress-service.yml

kubectl patch deployments -n ingress-nginx nginx-ingress-controller -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx-ingress-controller","ports":[{"containerPort":80,"hostPort":80},{"containerPort":443,"hostPort":443}]}],"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'

echo "CREATED :::>>> K8S Ingress Controller for EWS ::: [[[ ${ENVIRONMENT} ]]]..."

#echo "CREATING :::>>> K8S Ingress Service for EWS ::: [[[ ${ENVIRONMENT} ]]]..."
#
#kubectl create -f kube-${ENVIRONMENT}/kube-ingress-routes.yml
#
#echo "CREATED :::>>> K8S Ingress Service for EWS ::: [[[ ${ENVIRONMENT} ]]]..."

exit 0
