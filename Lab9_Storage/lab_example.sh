#!/usr/bin/env bash
kubectl get nodes -o yaml | grep labels -A 7
#kubectl apply -f __PATH_TO_DRIVER__
kubectl apply -f csi-driver-deployments-master/aws-ebs/kubernetes/latest/
kubectl get storageclass
kubectl describe storageclass
kubectl describe pvc ebs-gp2

# TODO loop until the csi pod appears
kubectl get pods -n kube-system | grep csi

# deploy first app
kubectl apply -f csi-driver-deployments-master/aws-ebs/kubernetes/example-dynamic/
kubectl get pvc -w
# use the kubectl describe pvc to see the full status
# point out 'VolumeHandle' and check AWS console
kubectl describe pv
# get pod name
kubectl get pods
# point out when the pod started writing data
kubectl exec -it __POD__ cat /data/out.txt
# delete pod
kubectl get pods
# deleting the pods takes a few seconds because the driver is unmounting the volume and detaching from the instance
kubectl delete pods __POD__
# point out again when the pod started writing data, data persisted across pod restart
kubectl exec -it __POD__ cat /data/out.txt

# create a new volume in the same AZ as the cluster in the AWS console, get volumeID
# edit pre-provisioned/pv.yaml 'volumeHandle'
# a use case is using an existing EBS volume in a new cluster
kubectl apply -f pre-provisioned/

# delete dynamic deployment
kubectl delete deployment ebs-dynamic-app
# check AWS console, the volume will be "available"
kubectl delete pvc dynamic
# check AWS console, the volume will be deleted and not show up

# delete dynamic deployment
kubectl delete deployment ebs-pre-provisioned-app
# delete PV and PVC
kubectl delete pvc dynamic
kubectl delete pv pre-provisioned
# check AWS console, the volume will be "available" and not deleted because 'persistentVolumeReclaimPolicy: Retain'
# the same EBS volume can be reused in other pods

