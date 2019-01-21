#!/usr/bin/env bash
set -x
# TODO Setup the lab examples which contain steps the attendees will execute
# TODO Update links in the README.md file
dcos kubernetes cluster create --yes --options=k8s_options1.json
dcos kubernetes cluster create --yes --options=k8s_options2.json
dcos kubernetes cluster create --yes --options=k8s_options3.json
dcos kubernetes cluster create --yes --options=k8s_options4.json
dcos kubernetes cluster create --yes --options=k8s_options5.json
dcos kubernetes cluster create --yes --options=k8s_options6.json
#dcos kubernetes cluster create --yes --options=k8s_options7.json
echo "==================================="
echo " Waiting for K8s to finish installation"
echo "==================================="
i=0
while [ $i -ne 1 ]
do
i=$(dcos kubernetes cluster debug plan status deploy --cluster-name=kubernetes-cluster1 | grep -c "deploy (serial strategy) (COMPLETE)")
sleep 10
done
echo "K8s Cluster 1 installed"
echo "==================================="
echo " Waiting for K8s to finish installation"
echo "==================================="
i=0
while [ $i -ne 1 ]
do
i=$(dcos kubernetes cluster debug plan status deploy --cluster-name=kubernetes-cluster2 | grep -c "deploy (serial strategy) (COMPLETE)")
sleep 10
done
echo "K8s Cluster 2 installed"


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

#########
export EDGELB_PUBLIC_AGENT_IP=$(dcos task exec -it edgelb-pool-0-server curl ifconfig.co)
export PUBLIC_IP="${EDGELB_PUBLIC_AGENT_IP/$'\r'/}"



dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --verbose \
    --context-name=kubernetes-cluster2 \
    --cluster-name=kubernetes-cluster2 \
    --apiserver-url=https://${PUBLIC_IP}:6444

kubectl config use-context kubernetes-cluster2
kubectl get nodes
kubectl apply -f https://k8s.io/examples/application/deployment.yaml
sleep 5
kubectl get deployments
kubectl proxy

# open in browser:::  http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

# TODO Update the readme
# TODO Deploy a sample application

