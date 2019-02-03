#!/bin/sh

set -e

ip=$(hcloud server list | awk '/001/ {print $4}')

# create local config folder
mkdir -p ~/.kube

# backup old config if required
[ -f ~/.kube/config ] && cp -f ~/.kube/config ~/.kube/config.backup.$$

# copy config from master node
scp root@${ip}:/etc/kubernetes/admin.conf ~/.kube/config

# change config to use correct IP address
kubectl config set-cluster kubernetes --server=https://${ip}:6443

kubectl get nodes
