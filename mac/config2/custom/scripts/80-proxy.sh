#!/bin/bash
set -euo pipefail

cat <<- EOF > /etc/systemd/system/kubectl-port-forward.service
[Unit]
Description=Kubectl Port Forward for OpenWeb-UI Service
Requires=k3s.service
PartOf=k3s.service
After=k3s.service
ConditionPathExists=/opt/bin/kubectl
ConditionPathExists=/etc/rancher/k3s/k3s.yaml


[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStartPre=/bin/sh -c 'until systemctl is-active --quiet k3s.service; do sleep 10; done'
ExecStart=/opt/bin/kubectl port-forward svc/open-webui 8080:80 --namespace=ollama --kubeconfig=/etc/rancher/k3s/k3s.yaml
Restart=on-failure
RestartSec=60

[Install]
WantedBy=multi-user.target
EOF

systemctl enable kubectl-port-forward.service