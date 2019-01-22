#!/usr/bin/env bash
# WARNING: Before running this ensure you are logged into AWS CLI and that ssh-add -l has the appropriate keys available
# TODO - define the Kubernetes cluster specific users mke{n}
# TODO - Finish the installation documentation
set -x
eval $(maws li 110465657741_Mesosphere-PowerUser)
export AWS_DEFAULT_REGION="us-west-2"


terraform init -input=false
terraform apply -input=false
export DCOS_MASTER="$(terraform output cluster-address )"
export DCOS_MASTER="${DCOS_MASTER/$'\r'/}"
export public_node="$(terraform output public-agents-loadbalancer)"
export public_node="${public_node/$'\r'/}"
echo "Waiting for DC/OS startup to complete"
sleep 90
#
dcos cluster setup --username bootstrapuser --password deleteme --no-check ${DCOS_MASTER}
sleep 10
dcos node
echo "====================================="
echo " Install Kubernetes users "
echo "====================================="
sh ./mke_groups_setup.sh
sh ./mke_users_setup.sh 1
sh ./mke_users_setup.sh 2
sh ./mke_users_setup.sh 3
sh ./mke_users_setup.sh 4
sh ./mke_users_setup.sh 5
sh ./mke_users_setup.sh 6
sh ./mke_users_setup.sh 7

echo "==================================="
echo " Install Edge"
echo "==================================="
## Setup Edge-LB
dcos package install --yes dcos-enterprise-cli
sleep 10
dcos package repo add --index=0 edgelb-pool https://downloads.mesosphere.com/edgelb-pool/v1.2.1/assets/stub-universe-edgelb-pool.json
dcos package repo add --index=0 edgelb https://downloads.mesosphere.com/edgelb/v1.2.1/assets/stub-universe-edgelb.json

dcos security org service-accounts keypair edge-lb-private-key.pem edge-lb-public-key.pem
dcos security org service-accounts create -p edge-lb-public-key.pem -d "Edge-LB service account" edge-lb-principal
dcos security org service-accounts show edge-lb-principal
dcos security secrets create-sa-secret --strict edge-lb-private-key.pem edge-lb-principal dcos-edgelb/edge-lb-secret
dcos security org groups add_user superusers edge-lb-principal



dcos security org service-accounts keypair private-key.pem public-key.pem

sh ./create_k8s_svc_accnt.sh kubernetes
dcos package install kubernetes --yes  --options=kubernetes-engine.json
sleep 60
dcos package install --options=edge-lb-options.json edgelb --yes
j="ABC"
while [ "$j" != "pong" ]
do
    sleep 10
    j=$(dcos edgelb ping)
done
sleep 10
dcos edgelb create edgelb.json
sleep 10
#edge_cnt=0
#while [ $edge_cnt -eq 0 ]
#do
#    sleep 5
#    j=$(dcos edgelb list | grep -c "edgelb-kubernetes-cluster-proxy-basic")
#done
echo "==================================="
echo " Edge Installation Complete"
echo "==================================="
dcos edgelb list
dcos edgelb status edgelb-kubernetes-cluster-proxy-basic
dcos edgelb endpoints edgelb-kubernetes-cluster-proxy-basic
dcos task exec -it edgelb-pool-0-server curl ifconfig.co

# Define the workshop service accounts and permissions
sh ./create_k8s_svc_accnt.sh kubernetes-cluster1
sh ./create_k8s_svc_accnt.sh kubernetes-cluster2
sh ./create_k8s_svc_accnt.sh kubernetes-cluster3
sh ./create_k8s_svc_accnt.sh kubernetes-cluster4
sh ./create_k8s_svc_accnt.sh kubernetes-cluster5
sh ./create_k8s_svc_accnt.sh kubernetes-cluster6
sh ./create_k8s_svc_accnt.sh kubernetes-cluster7

# TODO See if it is possible to deploy the different kubernetes clusters in different application groups.

