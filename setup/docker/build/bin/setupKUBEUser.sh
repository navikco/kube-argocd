#!/bin/sh

set -e

echo "###Setup kubeadmin User###"

#groupadd kube
adduser -g kubeadmin -s /bin/sh kubeadmin -D

#useradd -ms /bin/bash kubeadmin
#usermod -G kube kubeadmin

#echo "p@ss10n" | passwd --stdin kubeadmin
echo 'kubeadmin:p@ss10n' | chpasswd

#echo "kubeadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
id kubeadmin
