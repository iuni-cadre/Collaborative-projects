Following https://eksworkshop.com/introduction/ for AWS EKS setup

Testing cloude9 IDE (default size node with 2hour sleeping time)

Install kubectl on the nanoIDE, following https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

following https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html 
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
aws-iam-authenticator help

eksctl create cluster eks-kubeflow --node-ami=auto --node-type=p2.xlarge --nodes 1 --region us-west-2 --timeout=40m
if failed, clean up the cluster:
eksctl delete cluster --region=us-west-2 --name=eks-kubeflow

########Consider redo  using homebrew##########https://github.com/weaveworks/eksctl/issues/209
To be continued...setup kubernetes dashborad https://eksworkshop.com/introduction/

-----------------------------------------------------------------------------------
Following https://aws.amazon.com/blogs/opensource/kubeflow-amazon-eks/ for kubeflow setup

kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.10/nvidia-device-plugin.yml

kubectl get pods -n kube-system -owide |grep nvid

kubectl get nodes \
 "-o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu,EC2:.metadata.labels.beta\.kubernetes\.io/instance-type,AZ:.metadata.labels.failure-domain\.beta\.kubernetes\.io/zone"

--install ksonnet and kubeflow see "kubeflow.bash"

KUBEFLOW_SRC=kubeflow
KUBEFLOW_TAG=v0.4.1
KFAPP=mykubeflowapp

mkdir ${KUBEFLOW_SRC}
cd ${KUBEFLOW_SRC}

curl https://raw.githubusercontent.com/kubeflow/kubeflow/${KUBEFLOW_TAG}/scripts/download.sh | bash

~/environment/kubeflow/scripts/kfctl.sh init ${KFAPP} --platform none

cd ${KFAPP}

~/environment/kubeflow/scripts/kfctl.sh generate platform
~/environment/kubeflow/scripts/kfctl.sh apply platform

~/environment/kubeflow/scripts/kfctl.sh generate k8s
~/environment/kubeflow/scripts/kfctl.sh apply k8s
