#!/usr/bin/env bash
# TODO Why won't cluster1 kubeconfig setup?
# TODO Prepare team worksheets to setup the clusters
set -x

export EDGELB_PUBLIC_AGENT_IP=$(dcos task exec -it edgelb-pool-0-server curl ifconfig.co)
export PUBLIC_IP="${EDGELB_PUBLIC_AGENT_IP/$'\r'/}"



dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --verbose \
    --context-name=kubernetes-cluster1 \
    --cluster-name=kubernetes-cluster1 \
    --apiserver-url=https://${PUBLIC_IP}:6444


kubectl config use-context kubernetes-cluster1
kubectl get nodes

