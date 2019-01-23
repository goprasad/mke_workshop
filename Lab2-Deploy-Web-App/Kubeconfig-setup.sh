#!/usr/bin/env bash
# $1 = kubernetes cluster number
# $2 = port number

set -x
echo $1, $2
#dcos auth login --username mke$1 --password "mesosphere"

export EDGELB_PUBLIC_AGENT_IP=$(dcos task exec -it edgelb-pool-0-server curl ifconfig.co)
export PUBLIC_IP="${EDGELB_PUBLIC_AGENT_IP/$'\r'/}"



dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --verbose \
    --context-name=kubernetes-cluster$1 \
    --cluster-name=kubernetes-cluster$1 \
    --apiserver-url=https://${PUBLIC_IP}:$2

sleep 10
kubectl config use-context kubernetes-cluster$1
kubectl get nodes

dcos service

dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --verbose \
    --context-name=kubernetes-cluster1 \
    --cluster-name=kubernetes-cluster1 \
    --apiserver-url=https://54.212.63.7:6444