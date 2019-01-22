# Lab 3: Deploy a Kubernetes Cluster


## Overview

During this lab you will learn the following:
* How to use the ```dcos kubernetes``` command line tool 
* Scale up the kubernetes cluster and add additional nodes
* Simulate the loss of a Kubernetes node loss and DC/OS recovery of that node

**Estimated time required:** 15 minutes
 
## Requirements
* A healthy DC/OS Cluster with at least 8 nodes
* 'kubernetes' user defined with password 'password'
* 'kubernetes-cluster1' service account is defined


## Part I: Scale up the Kubernetes Cluster
1. Click the edit button for the kubernetes-cluster1, then select the 'kubernetes' section
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-0.png)

1. Change the node count from 1 to 5 as shown below
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-1.png)

1. Click review and run to confirm the properties are properly selected
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-2.png)

1. Click on the cluster name and then details to observe the additional 4 nodes getting added


## Part II: Automated Self Healing

1. Kubernetes with DC/OS includes automated self-healing of Kubernetes infrastructure.

We can demo this by killing the etcd-0 component of one of the Kubernetes cluster

List your Kubernetes tasks:
```
dcos task | grep etcd
```
Output should resemble below
```
$ dcos task | grep etcd
etcd-0-peer                                    172.12.25.146   root     R    kubernetes-cluster2__etcd-0-peer__c09966b0-379e-4519-ae10-5683db4926b0                           fc11bc38-dd26-4fbb-9011-cca26231f64b-S0  us-west-2  us-west-2b
etcd-0-peer                                    172.12.25.146   root     R    kubernetes-cluster1__etcd-0-peer__98e0bc46-a7d7-4553-8749-a9bafb624ae1                           fc11bc38-dd26-4fbb-9011-cca26231f64b-S0  us-west-2  us-west-2b
```
 
Run the command below to kill the etcd-0 component of kubernetes-cluster1:
```
dcos task exec -it kubernetes-cluster1__etcd-0 bash -c 'kill -9 $(pidof etcd)'
```

1. DC/OS ensures that any unhealthy / destroyed nodes are moved to a healthy node in the DC/OS cluster
# TODO figure out a good way to delete a kubernetes node and demonstrate the recovery




