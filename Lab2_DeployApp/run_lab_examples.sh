#!/usr/bin/env bash
set -x
# Istio Bookinfo link: https://istio.io/docs/examples/bookinfo/
# istio getting started: https://www.katacoda.com/courses/istio/deploy-istio-on-kubernetes
# https://istio.io/docs/tasks/traffic-management/ingress/#determining-the-ingress-ip-and-ports
kubectl apply -f <(istioctl kube-inject -f bookinfo/platform/kube/bookinfo.yaml)
kubectl label namespace default istio-injection=enabled
kubectl apply -f bookinfo/platform/kube/bookinfo.yaml
kubectl get services
kubectl get pods

# Determining the ingress IP and port
kubectl apply -f bookinfo/networking/bookinfo-gateway.yaml
kubectl get gateway
kubectl get svc istio-ingressgateway -n istio-system
#export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
#export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
#export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
# TODO Identify the ingress host to use
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

# Confirm the app is running
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage


# the value should be 200 if successful

# Install the istioctl command line app
brtew install istioctl

# Download istio
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.0.0 sh -

# Extend Kubernetes for Istio
kubectl apply -f install/kubernetes/helm/istio/templates/crds.yaml -n istio-system

#Enforce mutual TLS authentication by default
kubectl apply -f install/kubernetes/istio-demo-auth.yaml

# Verify istio services exist
kubectl get pods -n istio-system
kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/platform/kube/bookinfo.yaml)
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get pods
kubectl apply -f samples/bookinfo/networking/destination-rule-all-mtls.yaml

dcos edgelb create istio-edgleb.json
dcos edgelb list
dcos edgelb show istio-ingress-pool
dcos edgelb status istio-ingress-pool
dcos task exec -it istio-ingress-pool curl ifconfig.co

#
### Deploy v2
cat samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-test-v2.yaml
#
### Traffic shaping for canary releases to v3
cat samples/bookinfo/networking/virtual-service-reviews-50-v3.yaml
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-50-v3.yaml

# List all the service routes
istioctl get virtualservices
istioctl get virtualservices -o yaml

#
## Access Metrics
while true; do
  curl -s https://2886795272-80-elsy02.environments.katacoda.com/productpage > /dev/null
  echo -n .;
  sleep 0.2
done


