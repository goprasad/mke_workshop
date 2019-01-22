#!/usr/bin/env bash
set -x

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




i=0
while [ $i -ne 1 ]
do
i=$(dcos kubernetes cluster debug plan status deploy --cluster-name=kubernetes-cluster6 | grep -c "deploy (serial strategy) (COMPLETE)")
sleep 10
done
echo "K8s Cluster 6 installed"


