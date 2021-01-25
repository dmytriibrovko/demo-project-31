######################
# Create The Cluster #
######################

az login

az provider register -n Microsoft.Network

az provider register -n Microsoft.Storage

az provider register -n Microsoft.Compute

az provider register -n Microsoft.ContainerService

az group create \
    --name istio \
    --location eastus

az aks create \
    --resource-group istio \
    --name istio \
    --node-count 3 \
    --node-vm-size Standard_D2s_v3 \
    --generate-ssh-keys \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 6

az aks get-credentials \
    --resource-group istio \
    --name istio

#######################
# Destroy the cluster #
#######################

az group delete \
    --name istio \
    --yes

kubectl config delete-cluster istio

kubectl config delete-context istio

kubectl config unset \
    users.clusterUser_istio_istio