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
  creationTimestamp: "2023-07-10T20:36:00Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "766"
  uid: 68d3d8ec-265f-4300-9ea6-f1905f92fa1f
```
