following https://www.kubeflow.org/docs/components/ksonnet/ for ksonnet installation on exisiting kubernetes client

    1. Follow the ksonnet installation guide, choosing the relevant options for your operating system. For example, if you’re on Linux:

        Set some variables for the ksonnet version:

        KS_VER=0.13.1
        KS_PKG=ks_${KS_VER}_linux_amd64

        Download the ksonnet package:

        wget -O /tmp/${KS_PKG}.tar.gz https://github.com/ksonnet/ksonnet/releases/download/v${KS_VER}/${KS_PKG}.tar.gz

        Unpack the file:

        mkdir -p ${HOME}/bin
        tar -xvf /tmp/$KS_PKG.tar.gz -C ${HOME}/bin

    2. Add the ks command to your path:

      PATH=$PATH:${HOME}/bin/$KS_PKG
      
-----------------------------------------------------------------------------------
following https://github.com/Azure/kubeflow-labs/tree/master/4-kubeflow for kubeflow deployment on azure

KUBEFLOW_SRC=kubeflow
KUBEFLOW_TAG=v0.4.1
KFAPP=mykubeflowapp

mkdir ${KUBEFLOW_SRC}
cd ${KUBEFLOW_SRC}
cd ${KFAPP}

curl https://raw.githubusercontent.com/kubeflow/kubeflow/${KUBEFLOW_TAG}/scripts/download.sh | bash

# Initialize a kubeflow app
~/kubeflow/scripts/kfctl.sh init ${KFAPP} --platform none

~/kubeflow/scripts/kfctl.sh generate platform
~/kubeflow/scripts/kfctl.sh apply platform

# Generate kubeflow app
~/kubeflow/scripts/kfctl.sh generate k8s
# Deploy Kubeflow app
~/kubeflow/scripts/kfctl.sh apply k8s

kubectl get pods -n kubeflow

-----------------------------------------------------------------------------------
Following https://github.com/Azure/kubeflow-labs/blob/master/5-jupyterhub/README.md for JupyterHub public IP:

To update the default service created for JupyterHub, run the following command to change the service to type LoadBalancer:
cd ~/kubeflow/mykubeflowapp/ks_app
ks param set jupyter serviceType LoadBalancer
cd ..
~/kubeflow/scripts/kfctl.sh apply k8s

kubectl get svc -n kubeflow

-----------------------------------------------------------------------------------
Follwing https://www.kubeflow.org/docs/started/getting-started-gke/ for GKE deployment

If you see Authorized domains, enter
kubeflowTest.cloud.goog

Save then create new credentials:
    Click Create credentials, and then click OAuth client ID.
    Under Application type, select Web application.
    In the Authorized redirect URIs box, enter the following:
https://cadre.endpoints.kubeflowtest-233506/_gcp_gatekeeper/authenticate

The simplest way to deploy Kubeflow is to use the Kubeflow deployment web interface:

    Open https://deploy.kubeflow.cloud/ in your web browser.
    Sign in using a GCP account that has administrator privileges for your GCP project.
    Complete the form, following the instructions on the left side of the form. In particular, ensure that you enter the same deployment name as you used when creating the OAuth client ID.
    Click Create Deployment.
    
In 10 mins, Kubeflow will be available at the following URI: 
https://cadre.endpoints.kubeflowtest-233506.cloud.goog

