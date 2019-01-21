# Lab 1: Deploy a Kubernetes Cluster

**TODO - Clean this up for the workshop**

## Requirements
* A healthy DC/OS Cluster with at least 8 nodes
* 'kubernetes' user defined with password 'password'
* 'kubernetes-cluster1' service account is defined

## Part 1: Deploy a Kubernetes Cluster
### Add the Kubernetes Cluster 

1. Your cluster key properties

| Team Project Property | Project Value  |
|-----------------------|----------------|
| Cluster Name          |  ___________________________________              |
| Public IP Address     |  ___________________________________              |
|

1. Verify the Kubernetes Cluster Manager has deployed
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k_1-7.png)

1. Search for the Kubernetes Cluster option in the catalog
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-1.png)

1. Select the Kubernetes Cluster option and modify the default properties as shown in the screen prints below
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-2.png)


1. For the Kubernetes cluster service, specify the Service name as "kubernetes-cluster1", the "Service Account Name" as "kubernetes-cluster1" and the "Service Account Secret" to "kubernetes-cluster1/sa"
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-3.png)

1. Specify the Cpus to 1 as part of the "Kubernetes" section definition
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-4a.png)

1. Specify the kube-Cpus to 1 as part of the "Kubernetes" section definition.
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-4b.png)

1. Review the Calico CNI network section (You will not need to make any changes)
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-4c.png)

1. Change the etcd CPU count to 1
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-5.png)


1. Click review and run to confirm the properties are properly selected, then click on "Run Service"
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-6.png)


![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-7.png)

![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-8.png)

1. Click on the cluster name and explore the options while the cluster is deploying
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-2-9.png)

### Scale up the Kubernetes Cluster
1. Click the edit button for the kubernetes-cluster1, then select the 'kubernetes' section
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-0.png)

1. Change the node count from 1 to 5 as shown below
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-1.png)

1. Click review and run to confirm the properties are properly selected
![](https://raw.githubusercontent.com/markfjohnson/SBC_demo/master/Legacy/images/k-3-2.png)

1. Click on the cluster name and then details to observe the additional 4 nodes getting added

# TODO Address this section
1. Find and review the Kubernetes documentation on-line.
Mesosphere Kubernetes Engine/Cluster Documentation: https://docs.mesosphere.com/services/kubernetes/2.1.1-1.12.4

## Part II: Automated Self Healing

Kubernetes with DC/OS includes automated self-healing of Kubernetes infrastructure.

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
      ` 
Navigate to the DC/OS UI: Navigate to the DC/OS UI > Services > Kubernetes tab and open next to the terminal so you can see the components in the DC/OS UI. Use the search bar to search for etcd to observe auto-healing capabilities
![]()


Run the command below to kill the etcd-0 component of kubernetes-cluster1:

dcos task exec -it kubernetes-cluster1__etcd-0 bash -c 'kill -9 $(pidof etcd)'


