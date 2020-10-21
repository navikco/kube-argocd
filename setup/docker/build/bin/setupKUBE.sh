#!/bin/sh

set -e

./bin/setupKUBEUser.sh

chown kubeadmin:kubeadmin -R /opt/mw/apps/kube/

chown kubeadmin:kubeadmin -R /opt/mw/

chmod 775 -R /opt/mw/
