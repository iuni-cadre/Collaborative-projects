Following https://aws.amazon.com/blogs/opensource/kubeflow-amazon-eks/ for AWS kubeflow setup

Testing nano-sized cloude9 IDE

Install kubectl on the nanoIDE, following https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

eksctl create cluster eks-kubeflow --node-type=p2.xlarge --nodes 1 --region us-east-2 --timeout=40m
if failed, clean up the cluster:
eksctl delete cluster --region=us-east-1 --name=eks-kubeflow
