## EKS Practice

Simple cluster with 1 EC2 node and ready to deploy a K8 Service

### To run TF scripts

```
terraform apply
```

### To run K8 script

```
cd k8-apps/
aws eks update-kubeconfig --name eks-cluster #connects kubectl with the cluster
kubectl apply nginx-deployment.yml
kubectl apply ngnx-service.yml
kubectl get pod
```
