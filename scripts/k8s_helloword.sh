#!/bin/sh

set -e

app="hello-world"
ip=$(hcloud server list | awk '/001/ {print $4}')
port=8080
type=ClusterIP
replicas=3

case "$1" in
  "deploy")
    kubectl run ${app} \
      --replicas=${replicas} \
      --labels="run=example" \
      --image=gcr.io/google-samples/node-hello:1.0  \
      --port=${port}

    kubectl expose deployment ${app} \
      --type=${type} \
      --name=${app}-svc

    cat <<EOF | kubectl create -f -
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ${app}-ing
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: ${app}.${ip}.xip.io
    http:
      paths:
      - path: /
        backend:
          serviceName: ${app}-svc
          servicePort: $port
EOF
  ;;
status)
  kubectl get deployments $app
  kubectl describe deployments $app
  echo
  kubectl get services $app-svc
  echo
  kubectl get ingress $app-ing
  ;;
run)
  curl "${app}.${ip}.xip.io"
 ;;
clean)
  kubectl delete ingress ${app}-ing
  kubectl delete services ${app}-svc
  kubectl delete deployment ${app}
  ;;
*)
  echo "Usage: $(basename "$0") {deploy|clean|status|run}"
  exit 1
  ;;
esac
