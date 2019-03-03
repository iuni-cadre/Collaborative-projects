following https://www.kubeflow.org/docs/components/ksonnet/ for ksonnet installation on exisiting kubernetes client

    1. Follow the ksonnet installation guide, choosing the relevant options for your operating system. For example, if you’re on Linux:

        Set some variables for the ksonnet version:

        export KS_VER=0.13.1
        export KS_PKG=ks_${KS_VER}_linux_amd64

        Download the ksonnet package:

        wget -O /tmp/${KS_PKG}.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v${KS_VER}/${KS_PKG}.tar.gz

        Unpack the file:

        mkdir -p ${HOME}/bin
        tar -xvf /tmp/$KS_PKG.tar.gz -C ${HOME}/bin

    2. Add the ks command to your path:

      export PATH=$PATH:${HOME}/bin/$KS_PKG
      
-----------------------------------------------------------------------------------
following https://github.com/Azure/kubeflow-labs/tree/master/4-kubeflow for kubeflow deployment on azure

KUBEFLOW_SRC=kubeflow

mkdir ${KUBEFLOW_SRC}
cd ${KUBEFLOW_SRC}

export KUBEFLOW_TAG=v0.4.1

curl https://raw.githubusercontent.com/kubeflow/kubeflow/${KUBEFLOW_TAG}/scripts/download.sh | bash

# Initialize a kubeflow app
KFAPP=mykubeflowapp
scripts/kfctl.sh init ${KFAPP} --platform none

# Generate kubeflow app
cd ${KFAPP}
~/kubeflow/scripts/kfctl.sh generate k8s

# Deploy Kubeflow app
~/kubeflow/scripts/kfctl.sh apply k8s

kubectl get pods -n kubeflow
