## EKS Practice

Simple cluster with 1 EC2 node and ready to deploy a K8 Service

### Modify variables.tf

I'm using ids for my AWS Account, you should replace these with your own.

### To run TF scripts

```
terraform init
terraform apply
```

### To run K8 script

```
cd k8-apps/
aws eks update-kubeconfig --name eks-cluster #connects kubectl with the cluster
kubectl apply -f nginx-deployment.yml
kubectl apply -f nginx-service.yml
kubectl get pod
```

### To get the IP of the Cluster nodes

```
kubectl get nodes -o wide |  awk {'print $1" " $2 " " $7'} | column -t
```
