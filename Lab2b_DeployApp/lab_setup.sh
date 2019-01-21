#!/usr/bin/env bash
set -x

# Requirements validation and setup - Double check the kubectl is setup and ready for the example
kubectl cluster-info
kubectl get nodes
kubectl get pods --all-namespaces
kubectl apply -f helm-service-account.yaml
helm init --service-account tiller

# Install istio
# TODO helm problem
helm install install/kubernetes/helm/istio --name istio --namespace istio-system
kubectl get svc -n istio-system
kubectl get pods -n istio-system


