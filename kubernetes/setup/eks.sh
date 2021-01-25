####################
# Create a cluster #
####################

# Follow the instructions from https://github.com/weaveworks/eksctl to intall eksctl if you do not have it already

export AWS_ACCESS_KEY_ID=[...] # Replace [...] with the AWS Access Key ID

export AWS_SECRET_ACCESS_KEY=[...] # Replace [...] with the AWS Secret Access Key

export AWS_DEFAULT_REGION=us-west-2

export CLUSTER_NAME=devops-27

eksctl create cluster \
    -n $CLUSTER_NAME \
    -r $AWS_DEFAULT_REGION \
    --node-type t2.large \
    --nodes-max 6 \
    --nodes-min 3 \
    --asg-access \
    --managed

#############################
# Create Cluster Autoscaler #
#############################

IAM_ROLE=$(aws iam list-roles \
    | jq -r ".Roles[] \
    | select(.RoleName \
    | startswith(\"eksctl-$CLUSTER_NAME-nodegroup\")) \
    .RoleName")

aws iam put-role-policy \
    --role-name $IAM_ROLE \
    --policy-name $CLUSTER_NAME-AutoScaling \
    --policy-document https://raw.githubusercontent.com/vfarcic/k8s-specs/master/scaling/eks-autoscaling-policy.json

helm repo add stable \
    https://kubernetes-charts.storage.googleapis.com/

helm install aws-cluster-autoscaler \
    stable/cluster-autoscaler \
    --namespace kube-system \
    --set autoDiscovery.clusterName=$CLUSTER_NAME \
    --set awsRegion=$AWS_DEFAULT_REGION \
    --set sslCertPath=/etc/kubernetes/pki/ca.crt \
    --set rbac.create=true

#######################
# Destroy the cluster #
#######################

IAM_ROLE=$(aws iam list-roles \
    | jq -r ".Roles[] \
    | select(.RoleName \
    | startswith(\"eksctl-devops27-nodegroup\")) \
    .RoleName")

echo $IAM_ROLE

aws iam delete-role-policy \
    --role-name $IAM_ROLE \
    --policy-name devops27-AutoScaling

eksctl delete cluster -n devops27

# Delete unused volumes
for volume in `aws ec2 describe-volumes --output text| grep available | awk '{print $8}'`; do
    echo "Deleting volume $volume"
    aws ec2 delete-volume --volume-id $volume
done