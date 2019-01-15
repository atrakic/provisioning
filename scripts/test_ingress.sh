#!/bin/sh

set -e

service="test"
ip=$(hcloud server list | awk '/001/ {print $4}')

case "$1" in
  "deploy")
  # Create multiple YAML objects from stdin
  cat <<EOF | kubectl create -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ${service}-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: ${service}.${ip}.xip.io
    http:
      paths:
      - path: /
        backend:
          serviceName: ${service}-service
          servicePort: 443
EOF
  #kubectl rollout status ${service}-service
  ;;
status)
  kubectl get ingress
  ;;
run)
  curl ${service}.${ip}.xip.io
 ;;
delete)
  kubectl delete ingress ${service}-ingress
  ;;
*)
  echo "Usage: $(basename "$0") {deploy|undeploy|status|run}"
  exit 1
  ;;
esac
