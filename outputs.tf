output "configuration" {
  value = <<CONFIGURATION

Interact with hetzner.cloud:
  hcloud server list

Interact with k8s:
  kubectl get nodes
  kubectl cluster-info

CONFIGURATION
}

