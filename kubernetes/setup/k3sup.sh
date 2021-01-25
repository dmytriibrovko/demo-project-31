
curl -sLS https://get.k3sup.dev | sh
sudo cp k3sup /usr/local/bin/k3sup

k3sup install --ip $master_ip --user $user  --ssh-key $path_ssh

# Test your cluster with:
export KUBECONFIG=kubeconfig
kubectl config set-context default
kubectl get node -o wide

k3sup join --user dimabrovko --ssh-key=~/.ssh/id_rsa --server-ip $master_ip --ip $worker_ip