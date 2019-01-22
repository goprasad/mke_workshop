# Lab 2: Setup Kubernetes tools

# Overview
This lab is designed to expose the participant to setting up ```kubectl``` for your cluster, inspect the kubernetes cluster 
  As part of this lab you will have the opportunity to learn the following:
* Configure ```kubectl``` CLI
* How to inspect your Kubernetes cluster
* Work with the DC/OS CLI
* Log into DC/OS as a team admin user
* Connect to the Kubernetes dashboard
* Deploy a sample application to your cluster


**Estimated time required:** 30 minutes

# Pre-requisites
* Access to a Mesosphere Kubernetes Engine (MKE) cluster
* DC/OS login for just your cluster


| Team Project Property | Project Value  |
|-----------------------|----------------|
| CLUSTER_NAME          |  ___kubernetes-cluster{Team Number}____              |
| MKE Login     |  __mke{Team Number}/_mesosphere_______              | 
| EDGE_LB_PORT | __{6442 + Team Number}_________ |

## Part I: Setup ```kubectl```
1. Make certain that kubectl is installed on your client workstation

1. From the workstation command prompt login to DC/OS with your MKE Login and password
   ```angular2
   dcos auth login
   ```

   Assuming the login was successful you can proceed to the next step.
1. Set kubeconfig to point to your cluster

```
dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --verbose \
    --context-name=${CLUSTER_NAME} \
    --cluster-name=${CLUSTER_NAME} \
    --apiserver-url=https://${PUBLIC_IP}:EDGE_LB_PORT
```

Then to validate that the kubeconfig is properly setup, execute the following two commands:

```
kubectl config use-context ${CLUSTER_NAME}
kubectl cluster-info
kubectl get nodes
```

If successful, you will see a list of nodes associated with your Kubernetes cluster created in Lab 1 .  You are now ready to proceed to the next step so you can manage your cluster and Kubernetes services .

The user you have authorized yourself with will have access only to your Kubernetes clusters.  You can see the list of kubernetes clusters by entering the command below:
```
dcos service
```
You will see a service with your Kubernetes cluster CLUSTER_NAME in the output of this command.


## Part II: Access Kubernetes dashboard
As powerful as ```kubectl``` can be, often it is easier to utilize the Kubernetes dashboard.  The following instructions detail how to setup the kubernetes dashboard for your cluster.  Once we have kubeconfig setup for your kubernetes cluster,

The Kubernetes dashboard is accessible via a proxy.  To enable the proxy enter the following command:

```
kubectl proxy
```

**NOTE:** This command will not return the command line unless you run it in the background.

Now that the proxy is setup, open your browser to the url: ```http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/```

1. The browser will display the dashboard login screen as it appears below.  You will want to specify the kubeconfig directory at "~/.kube/config"

    ![](https://github.com/markfjohnson/mke_workshop/tree/master/Lab2-Deploy-Web-App/kubeconfig_login.png)

1. Upon successful login, you will see the main Kubernetes Dashboard as shown below
    ![](https://github.com/markfjohnson/mke_workshop/tree/master/Lab2-Deploy-Web-App/kubedashboard1.png)
    
1. Clicking on the "Nodes" icon wil show the nodes for your cluster as shown below:
    ![](https://github.com/markfjohnson/mke_workshop/tree/master/Lab2-Deploy-Web-App/kubedashboard2.png)

 
## Part III: Deploy a sample Application

The Kubernetes cluster is now ready to begin deploying applications.

# TODO Chose and deploy a sample application

