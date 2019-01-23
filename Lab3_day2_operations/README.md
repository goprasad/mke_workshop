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
![](images/k-3-0.png)

1. Change the node count from 4 to 5 as shown below
![](images/k-3-1.png)

1. Click review and run to confirm the properties are properly selected
![](images/k-3-2.png)

1. Click on the cluster name and then details to observe the additional 4 nodes getting added




