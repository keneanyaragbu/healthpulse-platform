#!/bin/bash
set -e

apt-get update -y
apt-get upgrade -y

curl -sfL https://get.k3s.io | K3S_TOKEN="${k3s_token}" sh -s - server \
  --write-kubeconfig-mode 644 \
  --tls-san $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) \
  --node-name k3s-master
