#!/bin/bash
sudo -i
echo "a1b2c3d4e5" | passwd ubuntu --stdin
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -s -
sudo cat >/var/lib/rancher/k3s/server/manifests/ingress-nginx.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ingress-nginx
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: ingress-nginx
  namespace: kube-system
spec:
  chart: ingress-nginx
  repo: https://kubernetes.github.io/ingress-nginx
  targetNamespace: ingress-nginx
  version: v3.29.0
  set:
  valuesContent: |-
    fullnameOverride: ingress-nginx
    controller:
      kind: DaemonSet
      hostNetwork: true
      hostPort:
        enabled: true
      service:
        enabled: false
      publishService:
        enabled: false
      config:
        use-forwarded-headers: "true"
EOF
helm install rfnchart /opt/rfnchart

