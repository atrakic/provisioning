#!/bin/bash 
set -e
kubectl apply -f manifests/ingress/00-namespace.yml
kubectl apply -f manifests/ingress/deployment.yml 
kubectl apply -f manifests/ingress/service.yml
kubectl apply -f manifests/ingress/configmap.yml

IP=$(hcloud server list | awk '/001/ {print $4}')
curl -s $IP.xip.io

