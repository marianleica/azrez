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
if (Test-Path -Path "C:\" -ErrorAction SilentlyContinue) {
Write-Output "${timestamp}; {${scenario}; RG: ${RG}; Location: ${location}; ResType: Distributed; ResName: ${VM}; Admin: ${admin} PublicIP: ${MASTER1IP}, ${MASTER2IP}, ${WORKER1IP}, ${WORKER2IP} ; Commands: ssh ${admin}@${MASTER1IP} , ssh ${admin}@${MASTER2IP} , ssh ${admin}@${WORKER1IP} , ssh ${admin}@${WORKER2IP} }" >> C:\azrez\azrez.log
} else {
    Write-Output "C drive not found, skipping logging."
}

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
Write-Output "The commands you need to run to set up the upstream kubernetes cluster via kubeadm are at:"
Write-Output "https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-upstreamKubernetes-kubeadm-runcommand-init.sh"
Write-Output ""
Read-Host "Press any key to continue..."
