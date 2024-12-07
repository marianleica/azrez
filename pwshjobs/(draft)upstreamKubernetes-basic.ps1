# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "upstreamKubernetes-infra"
$suffix=$(Get-Random -Minimum 100 -Maximum 999)
$suffix2=$(Get-Random -Minimum 10 -Maximum 99)
$RG="azrez"
$vnet="kubeadm"
$subnet="kube"
$admin="adm${suffix}"
$loc="uksouth"

# Step 1. Create infrastructure: VNET, NSG, 2 master VMs, 2 worker VMs, load balncer for master VMs
Write-Output "The resource group: "
az group create -n $RG -l $loc

Write-Output ""
Write-Output "The VNET $vnet"
az network vnet create --resource-group $RG --name $vnet --address-prefix 192.168.0.0/16 --subnet-name kube --subnet-prefix 192.168.0.0/16

Start-Sleep -Seconds 2
Write-Output ""
Write-Output "Adding required NSG rules: "
az network nsg create --resource-group $RG --name kubeadm

Start-Sleep -Seconds 2
az network nsg rule create --resource-group $RG --nsg-name kubeadm --name kubeadmssh --protocol tcp --priority 1000 --destination-port-range 22 --access allow

Start-Sleep -Seconds 2
az network nsg rule create --resource-group $RG --nsg-name kubeadm --name kubeadmWeb --protocol tcp --priority 1001 --destination-port-range 6443 --access allow

Start-Sleep -Seconds 2
Write-Output ""
Write-Output "Creating VNET subnet: "
az network vnet subnet update -g $RG -n $subnet --vnet-name $vnet --network-security-group kubeadm

Start-Sleep -Seconds 2
Write-Output ""
Write-Output "Creating Virtual Machines:"
az vm create -n kube-master-1 -g $RG --image Ubuntu2204 --vnet-name $vnet --subnet $subnet --admin-username $admin --generate-ssh-keys --size Standard_D2ds_v4 --nsg kubeadm --public-ip-sku Standard --no-wait
# modified from --ssh-key-value $HOME/.ssh/id_rsa.pub to --generate-ssh-keys <- it fails on blank environments

Start-Sleep -Seconds 2
az vm create -n kube-master-2 -g $RG --image Ubuntu2204 --vnet-name $vnet --subnet $subnet --admin-username $admin --generate-ssh-keys --size Standard_D2ds_v4 --nsg kubeadm --public-ip-sku Standard --no-wait

Start-Sleep -Seconds 2
az vm create -n kube-worker-1 -g $RG --image Ubuntu2204 --vnet-name $vnet --subnet $subnet --admin-username $admin --generate-ssh-keys --size Standard_D2ds_v4 --nsg kubeadm --public-ip-sku Standard --no-wait

Start-Sleep -Seconds 2
az vm create -n kube-worker-2 -g $RG --image Ubuntu2204 --vnet-name $vnet --subnet $subnet --admin-username $admin --generate-ssh-keys --size Standard_D2ds_v4 --nsg kubeadm --public-ip-sku Standard

Start-Sleep -Seconds 2
Write-Output ""
Write-Output "Creating the load balancer:"
az network public-ip create --resource-group $RG --name controlplaneip --sku Standard --dns-name $admin

Start-Sleep -Seconds 1
az network lb create --resource-group $RG --name kubemaster --sku Standard --public-ip-address controlplaneip --frontend-ip-name controlplaneip --backend-pool-name masternodes

Start-Sleep -Seconds 1
az network lb probe create --resource-group $RG --lb-name kubemaster --name kubemasterweb --protocol tcp --port 6443

Start-Sleep -Seconds 1
az network lb rule create --resource-group $RG --lb-name kubemaster --name kubemaster --protocol tcp --frontend-port 6443 --backend-port 6443 --frontend-ip-name controlplaneip --backend-pool-name masternodes --probe-name kubemasterweb --disable-outbound-snat true --idle-timeout 15 --enable-tcp-reset true

Start-Sleep -Seconds 1
az network nic ip-config address-pool add --address-pool masternodes --ip-config-name ipconfigkube-master-1 --nic-name kube-master-1VMNic --resource-group $RG --lb-name kubemaster

Start-Sleep -Seconds 1
az network nic ip-config address-pool add --address-pool masternodes --ip-config-name ipconfigkube-master-2 --nic-name kube-master-2VMNic --resource-group $RG --lb-name kubemaster

Start-Sleep -Seconds 5
Write-Output ""
Write-Output "Getting public IPs of all the Kubernetes nodes:"
$MASTER1IP=$(az vm list-ip-addresses -g $RG -n kube-master-1 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1
$MASTER2IP=$(az vm list-ip-addresses -g $RG -n kube-master-2 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1
$WORKER1IP=$(az vm list-ip-addresses -g $RG -n kube-worker-1 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1
$WORKER2IP=$(az vm list-ip-addresses -g $RG -n kube-worker-2 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1

# Logging
Write-Output "${timestamp}; {${scenario}; RG: ${RG}; Location: ${location}; ResType: Distributed; ResName: ${VM}; Admin: ${admin} PublicIP: ${MASTER1IP}, ${MASTER2IP}, ${WORKER1IP}, ${WORKER2IP} ; Commands: ssh ${admin}@${MASTER1IP} , ssh ${admin}@${MASTER2IP} , ssh ${admin}@${WORKER1IP} , ssh ${admin}@${WORKER2IP} }" >> C:\azrez\azrez.log

Write-Output ""
Write-Output "Save aside the setup details:"
Write-Output "VM node kube-master-1 has ${MASTER1IP}"
Write-Output "VM node kube-master-2 has ${MASTER2IP}"
Write-Output "VM node kube-worker-1 has ${WORKER1IP}"
Write-Output "VM node kube-worker-2 has ${WORKER2IP}"
Write-Output "The VM admin account is ${admin}"
Write-Output ""
Write-Output "The ssh commands for the nodes are:"
Write-Output "ssh ${admin}@${MASTER1IP}"
Write-Output "ssh ${admin}@${MASTER2IP}"
Write-Output "ssh ${admin}@${WORKER1IP}"
Write-Output "ssh ${admin}@${WORKER2IP}"
Write-Output ""
Read-Host "Press any key to continue..."

# the script doesn't proceed with the config after the ssh session is started
# we should put all lines below before the ssh prompt
# the procedure should be with az vm invoke command to the respective vm

sudo apt update && sudo apt upgrade -y

sudo swapoff -a

sudo sed -i '/ swap / s/^/#/' /etc/fstab

3

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt install -y containerd.io

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "(!)"
echo "Copy this information from the kubeadm init output to run on worker nodes be able to add them:"
echo "Below is an example, your output has an unique token"
echo "kubeadm join 192.168.0.4:6443 --token jjzu4e.xsrs0fknopxaqhhx --discovery-token-ca-cert-hash sha256:823ff397ce70aa7b3d99c2434bd07ddde27c0bf0c14d9c34eea1069ae9a44eb4"
echo ""
sudo kubeadm init

sleep 15

echo "Taking the kubeconfig file to be able to run kubectl commands:" 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml


kubectl get nodes


