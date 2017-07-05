Some commands..

oc new-app https://github.com/nikolaimerkel/kube-redis.git --name redis-docker
--> write image to petset

oc adm policy add-scc-to-user anyuid system:serviceaccount:merkel40:default
oc policy add-role-to-user edit system:serviceaccount:merkel40:default
oc policy add-role-to-user view system:serviceaccount:merkel40:default

oc create -f k8s/


oc logs po/redis-2 -c redis-node
oc rsh --container='redis-sidecar' pod/redis-0
cat /etc/pod-info/labels
--> Ausgabe
name="redis-node"
role="slave" bzw. master

oc describe pod redis-0 | grep role

oc rsh redis-2 
redis-cli
SET name merkel
GET name

oc delete pods --all

oc get all --show-labels=true


install nslookup in master container in a pod
nslookup -type=srv redis-nodes.merkel40.svc.cluster.local
--> Ausgabe:
Server:		192.168.64.2
Address:	192.168.64.2#53

redis-nodes.merkel40.svc.cluster.local	service = 10 33 0 redis-0.redis-nodes.merkel40.svc.cluster.local.
redis-nodes.merkel40.svc.cluster.local	service = 10 33 0 redis-1.redis-nodes.merkel40.svc.cluster.local.
redis-nodes.merkel40.svc.cluster.local	service = 10 33 0 redis-2.redis-nodes.merkel40.svc.cluster.local.



Nikolais-MacBook-Pro:~ nikolaimerkel$ oc get svc
NAME             CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
redis            172.30.131.133   <none>        6379/TCP   3h
redis-nodes      None             <none>        6379/TCP   3h
redis-readonly   172.30.10.207    <none>        6379/TCP   3h

oc describe svc/redis
Name:			redis
Namespace:		merkel40
Labels:			service=redis
Selector:		name=redis-node,role=master
Type:			ClusterIP
IP:			    172.30.131.133
Port:			redis	6379/TCP
Endpoints:		172.17.0.2:6379
Session Affinity:	None
No events.

oc get pods --show-labels=true
NAME      READY     STATUS    RESTARTS   AGE       LABELS
redis-0   3/3       Running   0          1h        name=redis-node,role=master
redis-1   3/3       Running   0          1h        name=redis-node,role=slave
redis-2   3/3       Running   0          1h        name=redis-node,role=slave


Nikolais-MacBook-Pro:~ nikolaimerkel$ oc delete pod/redis-0

Nikolais-MacBook-Pro:~ nikolaimerkel$ oc get pods --show-labels=true
NAME      READY     STATUS    RESTARTS   AGE       LABELS
redis-1   3/3       Running   0          1h        name=redis-node,role=master
redis-2   3/3       Running   0          1h        name=redis-node,role=slave

Nikolais-MacBook-Pro:~ nikolaimerkel$ oc describe svc/redis
Name:			redis
Namespace:		merkel40
Labels:			service=redis
Selector:		name=redis-node,role=master
Type:			ClusterIP
IP:			172.30.131.133
Port:			redis	6379/TCP
Endpoints:		172.17.0.4:6379
Session Affinity:	None
--> uses new master

oc delete all,pvc,petset -l name=redis-node
oc delete all,pvc,petset -l service=redis





# Redis on Kubernetes as StatefulSet

The following document describes the deployment of a self-bootstrapping, reliable,
multi-node Redis on Kubernetes. It deploys a master with replicated slaves, as
well as replicated redis sentinels which are use for health checking and failover.

## Prerequisites

This example assumes that you have a Kubernetes cluster installed and running,
and that you have installed the kubectl command line tool somewhere in your path.
Please see the getting started for installation instructions for your platform.

### Storage Class

This makes use of a StorageClass, either create a storage class with the name of
"ssd" or update the StatefulSet to point to to the correct StorageClass.

## Running

To get your cluster up and running simple run:

`kubectl apply -Rf k8s`

The cluster will automatically bootstrap itself.

### Caveats

Your pods may not show up in the dashboard. This is because we automatically add
additional labels to the pods to recognize the master. To see the pods within the
dashboard you should look at the redis-nodes service instead.
