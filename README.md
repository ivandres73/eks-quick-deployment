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

### Fix permissions to see resources in AWS Web-Console (Optional)

Run
```
kubectl edit configmap aws-auth -n kube-system
```

and copy:
```yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::849096285120:role/eks_node_role
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::849096285120:root
      groups:
      - system:masters
kind: ConfigMap
metadata:
  creationTimestamp: "2023-07-12T20:16:44Z" #this value varies
  name: aws-auth
  namespace: kube-system
  resourceVersion: "892"                    #this value varies
  uid: 2b98bfa1-29de-4120-9f74-dc25f69416f0 #this value varies
```

---

### Installation of Load Balancer Controller

1. 
```sh
kubectl apply -f k8-apps/aws-load-balancer-controller-service-account.yml
```

2. 
```sh
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```
