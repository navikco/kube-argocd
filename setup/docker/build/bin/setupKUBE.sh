#!/bin/sh

set -e

if [[ $# -eq 1 ]]
then

    MICROSERVICE=${1}
    echo "MICROSERVICE :::>>> ${MICROSERVICE}"

else
    echo "Usage: . ./setupKUBE.sh <<MICROSERVICE>>"
    exit 1
fi

./setupKUBEUser.sh

chown kubeadmin:kubeadmin -R /opt/mw/apps/kube/

chown kubeadmin:kubeadmin -R /opt/mw/

chmod 775 -R /opt/mw/
