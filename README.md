## EKS Practice

Simple cluster with 1 EC2 node and ready to deploy a K8 Service

> Disclaimer: this is not production-fit, because security practices are not followed, but that allows a quick setup and deployment

### Pre-requisites

In order to follow this guide, you should

1. have basic knowledge in aws
2. have basic knowledge in container-orchestration
3. have [aws-cli](https://aws.amazon.com/cli/) installed and configured
4. have [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) installed
5. have [helm](https://helm.sh/docs/intro/install/) installed
6. have [terraform](https://developer.hashicorp.com/terraform/downloads) installed
7. have a linux (debian-based) distro

### 1. Modify variables.tf

I'm using ids for my AWS Account, you should replace these with your own.

### 2. Apply TF scripts

```sh
terraform init
terraform apply
```

### 3. Connect Kubectl with EKS

```sh
aws eks update-kubeconfig --name eks-cluster
kubectl cluster-info #if this command works, you are good to continue
```

### 4. (optional) Fix permissions to see resources in AWS Web-Console


```sh
kubectl edit configmap aws-auth -n kube-system
```

and copy-paste (replace `account-id` for you actual aws account-id):

```yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::accound-id:role/eks_node_role
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::account-id:root
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

### 5.a Deploy a simple app with Classic-LoadBalancer (low difficulty)

```sh
cd k8-apps/
kubectl apply -f nginx-deployment.yml
kubectl apply -f nginx-service.yml
kubectl get services #here you will get the External-IP, copy it in your browser and should work
```

### 5.a (Optional) To get the IP of the Cluster nodes

If you want to expose the app as `NodePort` this command will be useful.

```sh
kubectl get nodes -o wide |  awk {'print $1" " $2 " " $7'} | column -t
```

---

### 5.b Deploy a simple app with Application-LoadBalancer (mid difficulty)

1. 
```sh
cd k8-apps/
kubectl apply -f lb-controller-service-account.yml
```

2. (double-check clusterName param)
```sh
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

3. add tags to vpc-subnets `kubernetes.io/role/elb = 1` if the subnet is public, and `kubernetes.io/role/internal-elb = 1` if private.

4. 
```sh
cd k8-apps/
kubectl apply -f 2048_full.yml
```

5.
```sh
kubectl get ingress -n game-2048 # copy the Address in your browser and it should work
```

#### References

In case you want to read more:

- https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
- https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
- https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer
