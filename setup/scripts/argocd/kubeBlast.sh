#!/bin/bash

set -e

if [[ $# -eq 1 ]]
then

    ENVIRONMENT=${1}
    echo "ENVIRONMENT :::>>> ${ENVIRONMENT}"

else
    echo "Usage: . ./kubeBlast.sh <<ENVIRONMENT>>"
    exit 1
fi

pkill -f k8dash | true

pkill -f 8081 | true

pkill -f 8000 | true

pkill -f 5000 | true

./destroyKubeCluster.sh

./createKubeCluster.sh

kind get clusters

./setupKubeIngress.sh ${ENVIRONMENT}

echo -e "\nSTART Pulling And Tagging :::>>> ARGO-CD images"
echo "!! Warning: Pulling images may take as long as 10 minutes to run the first time !!"

docker pull argoproj/argocd:v1.6.1
docker pull quay.io/dexidp/dex:v2.22.0
docker pull redis:5.0.3
docker tag argoproj/argocd:v1.6.1 localhost:5000/argoproj/argocd:v1.6.1
docker tag quay.io/dexidp/dex:v2.22.0 localhost:5000/quay.io/dexidp/dex:v2.22.0
docker tag redis:5.0.3 localhost:5000/redis:5.0.3

echo -e "FINISHED Pulling And Tagging :::>>> ARGO-CD images\n"

echo -e "\nSTART Pushing :::>>> ARGO-CD images from docker to kind registry"

docker push localhost:5000/argoproj/argocd:v1.6.1
docker push localhost:5000/quay.io/dexidp/dex:v2.22.0
docker push localhost:5000/redis:5.0.3

echo -e "FINISHED Pushing :::>>> ARGO-CD images from docker to kind registry\n"

echo "FORWARDING :::>>> PORTS in ::: [[[ ${ENVIRONMENT} ]]]..."

kubectl port-forward service/ingress-nginx 8081:80 --namespace=ingress-nginx &
kubectl port-forward service/tekton-dashboard 5005:9097 --namespace=kube-tekton-cd &


echo "FORWARDED :::>>> PORTS in ::: [[[ ${ENVIRONMENT} ]]]..."

./argocdBlast.sh ${ENVIRONMENT}

sleep 10

kubectl port-forward service/admin 9000:8080 --namespace=kube-${ENVIRONMENT} &
kubectl port-forward service/ingress-nginx 8080:80 --namespace=ingress-nginx &
kubectl port-forward deployment/k8dash 8000:4654 --namespace=kube-system &

exit 0
