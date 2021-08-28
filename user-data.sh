#!/bin/bash
sudo -i
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/lock_passwd: True/lock_passwd: False/g' /etc/cloud/cloud.cfg
sed -i 's/disable_root: True/disable_root: True/g' /etc/cloud/cloud.cfg
echo "ssh_pwauth:   true" >> /etc/cloud/cloud.cfg
service sshd restart
echo "a1b2c3d4e5" | passwd ubuntu --stdin
service sshd restart
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -s -
cat >/var/lib/rancher/k3s/server/manifests/ingress-nginx.yaml <<EOF
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
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm install rfnchart /opt/rfnchart

