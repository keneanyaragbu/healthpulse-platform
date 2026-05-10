#!/bin/bash
set -e

apt-get update -y
apt-get upgrade -y

MASTER_IP="${master_ip}"

until curl -sk https://$MASTER_IP:6443 > /dev/null 2>&1; do
  echo "Waiting for k3s master at $MASTER_IP..."
  sleep 10
done

curl -sfL https://get.k3s.io | K3S_URL="https://$MASTER_IP:6443" K3S_TOKEN="${k3s_token}" sh -s - agent \
  --node-name k3s-worker-${worker_index}
