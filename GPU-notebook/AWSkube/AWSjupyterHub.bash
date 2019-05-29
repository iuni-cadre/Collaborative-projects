eksctl create cluster eks-kubeflow --node-ami=auto --node-type=p2.xlarge --nodes 1 --region us-west-2 --timeout=40m
eksctl scale nodegroup --cluster=eks-jhub --nodes=1 ng-5711b853 --region us-west-2 --zones=us-west-2c,us-west-2b,us-west-2a
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.11/nvidia-device-plugin.yml
kubectl get pods -n kube-system -owide |grep nvid

du -a /home | sort -n -r | head -n 5

kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account=tiller
helm init --upgrade

kubectl -n kube-system delete deployment tiller-deploy
kubectl delete clusterrolebinding tiller
kubectl -n kube-system delete serviceaccount tiller
helm reset --force
