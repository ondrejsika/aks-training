[Ondrej Sika (sika.io)](https://sika.io) | <ondrej@sika.io> | [go to course ->](#course)

# AKS Training

## About Me - Ondrej Sika

**DevOps Engineer, Consultant & Lecturer**

Git, Gitlab, Gitlab CI, Docker, Kubernetes, Terraform, Prometheus, ELK / EFK

## Star, Create Issues, Fork, and Contribute

Feel free to star this repository or fork it.

If you find a bug, create an issue or pull request.

Also, feel free to propose improvements by creating issues.

## Live Chat

For sharing links & "secrets".

- Campfire - https://sika.link/join-campfire
- Slack - https://sikapublic.slack.com/
- Microsoft Teams
- https://sika.link/chat (tlk.io)

## Course

## Azure Container Registry

List ACRs

```
az acr list -o table
```

Get ACR credentials

```
az acr credential show -n sikatraining -o table
```

Login to ACR

```
az acr login -n sikatraining
```

## Azure Kubernetes Service

List clusters

```
az aks list -o table
```

Connect cluster

```
az aks get-credentials --resource-group <resource_group> --name <cluster_name> --overwrite-existing
```

eg.:

```
az aks get-credentials --resource-group aks-training --name aks-ad --overwrite-existing
```

## Create AKS Cluster using Azure CLI

```
az aks create \
  --resource-group aks-training \
  --name aks-cli \
  --node-count 2 \
  --generate-ssh-keys \
  --node-vm-size Standard_DS2_v2
```

## Ingress

## Install Ingress Nginx

```
helm upgrade --install \
  ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  --set controller.ingressClassResource.default=true \
  --set controller.metrics.enabled=true \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --wait
```

## Install Ingress Nginx on Existing IP

```
LOADBALANCER_IP=52.136.218.160
```

```
helm upgrade --install \
  ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --create-namespace \
  --namespace ingress-nginx \
  --set controller.ingressClassResource.default=true \
  --set controller.metrics.enabled=true \
  --set controller.service.loadBalancerIP=$LOADBALANCER_IP \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --wait
```

Install Cert-Manager

```
helm upgrade --install \
	cert-manager cert-manager \
	--repo https://charts.jetstack.io \
	--create-namespace \
	--namespace cert-manager \
	--set installCRDs=true \
	--wait
```

Create Cluster Issuer

```
kubectl apply -f ./examples/kubernetes/clusterissuer.yml
```

Test it

```
helm upgrade --install \
  hello-world hello-world \
  --repo https://helm.sikalabs.io \
  --set host=hello.aks.sikademo.com \
  --set replicas=1 \
  --set TEXT="Hello AKS" \
  --wait
```

## Thank you! & Questions?

That's it. Do you have any questions? **Let's go for a beer!**

### Ondrej Sika

- email: <ondrej@sika.io>
- web: <https://sika.io>
- twitter: [@ondrejsika](https://twitter.com/ondrejsika)
- linkedin: [/in/ondrejsika/](https://linkedin.com/in/ondrejsika/)
- Newsletter, Slack, Facebook & Linkedin Groups: <https://join.sika.io>

_Do you like the course? Write me a recommendation on Twitter (with handle `@ondrejsika`) and LinkedIn (add me [/in/ondrejsika](https://www.linkedin.com/in/ondrejsika/) and I'll send you Request for the recommendation). **Thanks**._

Wanna go for a beer or do some work together? Just [book me](https://book-me.sika.io) :)
