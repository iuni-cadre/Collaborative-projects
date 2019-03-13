Following instructions from https://zero-to-jupyterhub.readthedocs.io/en/latest/microsoft/step-zero-azure.html

az group create --name=<RESOURCE-GROUP-NAME> --location=centralus --output table

mkdir <CLUSTER-NAME>
cd <CLUSTER-NAME>

ssh-keygen -f ssh-key-<CLUSTER-NAME>

----restart here using browser bash----
az aks get-versions --location westus2 --output table
az aks create --name jupyterHub --resource-group KubernetsTest --ssh-key-value ssh-key-kubernet.pub --node-count 1 --node-vm-size Standard_NC6 --kubernetes-version 1.11.8 --location=westus2 --output table

az aks get-credentials --name jupyterHub --resource-group KubernetsTest --overwrite-existing --output table

kubectl get node

-----------------------------------------------------------------------------------
GPU debugging, following https://docs.microsoft.com/en-us/azure/aks/gpu-cluster

kubectl get nodes --output json | grep nvidia

kubectl create namespace gpu-resources
nano nvidia-device-plugin-ds.yaml

kubectl apply -f nvidia-device-plugin-ds.yaml
kubectl describe nodes

follow https://docs.microsoft.com/en-us/azure/aks/gpu-cluster to run sample GPU code
kubectl apply -f samples-tf-mnist-demo.yaml
kubectl get pods --selector app=samples-tf-mnist-demo
kubectl logs samples-tf-mnist-demo-smnr6
kubectl delete jobs samples-tf-mnist-demo

####breaking into the node by ssh#########
az vm user update --resource-group MC_KubernetsTest_jupyterHub_westus2 --name aks-nodepool1-39412713-0 --username azureuser --ssh-key-value ssh-key-kubernet.pub
az vm list-ip-addresses --resource-group MC_KubernetsTest_jupyterHub_westus2 -o table

--------------------------------------------------------------------------------
How follwing instructions from https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-helm.html

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

kubectl --namespace kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller --wait

kubectl patch deployment tiller-deploy --namespace=kube-system --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

helm version

--------------------------------------------------------------------------------
How follwing instructions from https://zero-to-jupyterhub.readthedocs.io/en/latest/setup-jupyterhub.html

openssl rand -hex 32
nano config.yaml

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

# Suggested values: advanced users of Kubernetes and Helm should feel
# free to use different values.
RELEASE=jhub
NAMESPACE=jhub

helm upgrade --install $RELEASE jupyterhub/jupyterhub   --namespace $NAMESPACE    --version=0.8.0   --values config.yaml

kubectl get pod --namespace jhub

kubectl get service --namespace jhub

helm upgrade -f config.yaml jhub jupyterhub/jupyterhub --version=0.8.0