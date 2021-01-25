######################
# Create The Cluster #
######################

gcloud auth login

# Open https://console.cloud.google.com/cloud-resource-manager to create a new project if you don't have one already

export PROJECT_ID=[...] # Replace [...] with the ID of the project

gcloud container clusters \
    create istio \
    --project $PROJECT_ID \
    --region us-east1 \
    --machine-type n1-standard-2 \
    --enable-autoscaling \
    --num-nodes 1 \
    --max-nodes 3 \
    --min-nodes 1

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

#######################
# Destroy the cluster #
#######################

gcloud container clusters \
    delete istio \
    --region us-east1 \
    --quiet

# Remove unused disks to avoid reaching the quota (and save a bit of money)
gcloud compute disks delete \
    --zone us-east1-b \
    $(gcloud compute disks list \
    --filter="zone:us-east1-b AND -users:*" \
    --format="value(id)")
gcloud compute disks delete \
    --zone us-east1-c \
    $(gcloud compute disks list \
    --filter="zone:us-east1-c AND -users:*" \
    --format="value(id)")
gcloud compute disks delete \
    --zone us-east1-d \
    $(gcloud compute disks list \
    --filter="zone:us-east1-d AND -users:*" \
    --format="value(id)")