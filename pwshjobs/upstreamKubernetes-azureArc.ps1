# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "upstreamKubernetes-infra"
$suffix=$(Get-Random -Minimum 100 -Maximum 999)
#$suffix2=$(Get-Random -Minimum 10 -Maximum 99)
$RG="azrez"
$vnet="kubeadm"
$subnet="kube"
$admin="adm${suffix}"
$loc="uksouth"
$subscriptionId=$(az account show --query id --output tsv)

# Step 1. Create infrastructure: VNET, NSG, 1 master VMs, 3 worker VMs, load balncer for master VM
Write-Output "The resource group: "
az group create -n $RG -l $loc -o table

Write-Output ""
Write-Output "The VNET $vnet"
az network vnet create --resource-group $RG --name $vnet --address-prefix 192.168.0.0/16 --subnet-name kube --subnet-prefix 192.168.0.0/16 -o table

Start-Sleep -Seconds 2
Write-Output ""
Write-Output "Adding required NSG rules: "
az network nsg create --resource-group $RG --name kubeadm

Start-Sleep -Seconds 2
az network nsg rule create --resource-group $RG --nsg-name kubeadm --name kubeadmssh --protocol tcp --priority 1000 --destination-port-range 22 --access allow

Start-Sleep -Seconds 2
az network nsg rule create --resource-group $RG --nsg-name kubeadm --name kubeadmWeb --protocol tcp --priority 1001 --destination-port-range 6443 --access allow

Start-Sleep -Seconds 2
az network nsg rule create --resource-group $RG --nsg-name kubeadm --name kubeadmapp --protocol tcp --priority 110 --destination-port-range 443 --access allow --direction Outbound

Start-Sleep -Seconds 2
az network nsg rule create --resource-group $RG --nsg-name kubeadm --name kubeadmregion --protocol tcp --priority 111 --destination-port-range 8084 --access allow --direction Outbound

#Start-Sleep -Seconds 2
#az network nsg rule create --resource-group $RG --nsg-name kubeadm --name kubeadmdns --protocol tcp --priority 112 --destination-port-range 53 --access allow --direction Outbound

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
az vm create -n kube-worker-0 -g $RG --image Ubuntu2204 --vnet-name $vnet --subnet $subnet --admin-username $admin --generate-ssh-keys --size Standard_D2ds_v4 --nsg kubeadm --public-ip-sku Standard --no-wait

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
#az network nic ip-config address-pool add --address-pool masternodes --ip-config-name ipconfigkube-master-2 --nic-name kube-master-2VMNic --resource-group $RG --lb-name kubemaster

Start-Sleep -Seconds 5
Write-Output ""
Write-Output "Getting public IPs of all the Kubernetes nodes:"
$MASTER1IP=$(az vm list-ip-addresses -g $RG -n kube-master-1 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1
$WORKER0IP=$(az vm list-ip-addresses -g $RG -n kube-worker-0 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1
$WORKER1IP=$(az vm list-ip-addresses -g $RG -n kube-worker-1 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1
$WORKER2IP=$(az vm list-ip-addresses -g $RG -n kube-worker-2 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
Start-Sleep -Seconds 1
Write-Output ""
#Write-Output "The commands you need to run to set up the upstream kubernetes cluster via kubeadm are at:"
#Write-Output "https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-upstreamKubernetes-kubeadm-runcommand-init.sh"
#Write-Output "Or apply quickly with:"
#Write-Output "sudo wget -O - https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-upstreamKubernetes-kubeadm-runcommand-init.sh | bash"
#Write-Output ""
#Start-Sleep -Seconds 2

# Run the kubeadm setup and init script commands inside the Master1 VM
az vm run-command create --resource-group $RG --async-execution false --run-as-user $admin --script "sudo wget -O - https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-upstreamKubernetes-kubeadm-runcommand-init.sh | bash" --timeout-in-seconds 3600 --run-command-name "KubeadmSetupAndInit" --vm-name kube-master-1
Start-Sleep -Seconds 1

# # Run the kubeadm setup and init script commands inside the other VMs
az vm run-command create --resource-group $RG --async-execution false --run-as-user $admin --script "sudo wget -O - https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-upstreamKubernetes-kubeadm-runcommand-setup.sh | bash" --timeout-in-seconds 3600 --run-command-name "KubeadmSetupAndInit" --vm-name kube-worker-0
Start-Sleep -Seconds 1
az vm run-command create --resource-group $RG --async-execution false --run-as-user $admin --script "sudo wget -O - https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-upstreamKubernetes-kubeadm-runcommand-setup.sh | bash" --timeout-in-seconds 3600 --run-command-name "KubeadmSetupAndInit" --vm-name kube-worker-1
Start-Sleep -Seconds 1
az vm run-command create --resource-group $RG --async-execution false --run-as-user $admin --script "sudo wget -O - https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-upstreamKubernetes-kubeadm-runcommand-setup.sh | bash" --timeout-in-seconds 3600 --run-command-name "KubeadmSetupAndInit" --vm-name kube-worker-2
Start-Sleep -Seconds 1

# Logging
if (Test-Path -Path "C:\" -ErrorAction SilentlyContinue) {
Write-Output "${timestamp}; {${scenario}; RG: ${RG}; Location: ${location}; ResType: Distributed; ResName: -; Admin: ${admin} PublicIP: ${MASTER1IP}, ${WORKER0IP}, ${WORKER1IP}, ${WORKER2IP} ; Commands: ssh ${admin}@${MASTER1IP} , ssh ${admin}@${WORKER0IP} , ssh ${admin}@${WORKER1IP} , ssh ${admin}@${WORKER2IP} }" >> C:\azrez\azrez.log
} else {
    Write-Output "C drive not found, skipping logging."
}

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "Installing GIT for the SCP utility:"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Output "Git is not installed. Installing Git for the SCP utility:"
    winget install --id Git.Git -e --source winget
    Start-Sleep -Seconds 2
} else {
    Write-Output "Git is already installed. Moving ahead."
}

Start-Sleep -Seconds 2

# Define the full path to the scp executable
$scpPath = "C:\Program Files\Git\usr\bin\scp.exe"

# Copy the kubeadmjoin.sh file to join the kubernetes cluster to the other nodes
#scp ${admin}@${MASTER1IP}:~/kubeadmjoin.sh ${admin}@${WORKER0IP}:~/
#scp ${admin}@${MASTER1IP}:~/kubeadmjoin.sh ${admin}@${WORKER1IP}:~/
#scp ${admin}@${MASTER1IP}:~/kubeadmjoin.sh ${admin}@${WORKER2IP}:~/

# Start-Process -FilePath $scpPath -ArgumentList "${admin}@${MASTER1IP}:~/kubeadmjoin.sh ${admin}@${WORKER0IP}:~/"
# Start-Process -FilePath $scpPath -ArgumentList "${admin}@${MASTER1IP}:~/kubeadmjoin.sh ${admin}@${WORKER1IP}:~/"
# Start-Process -FilePath $scpPath -ArgumentList "${admin}@${MASTER1IP}:~/kubeadmjoin.sh ${admin}@${WORKER2IP}:~/"
# Converting it into:
& $scpPath -o StrictHostKeyChecking=no "${admin}@${MASTER1IP}:~/kubeadmjoin.sh" "${admin}@${WORKER0IP}:~/"
& $scpPath -o StrictHostKeyChecking=no "${admin}@${MASTER1IP}:~/kubeadmjoin.sh" "${admin}@${WORKER1IP}:~/"
& $scpPath -o StrictHostKeyChecking=no "${admin}@${MASTER1IP}:~/kubeadmjoin.sh" "${admin}@${WORKER2IP}:~/"

# Run the kubeadm join command on the other nodes
Write-Output ""
Write-Output "Joining the other nodes to the cluster:"
Write-Output "Adding node WORKER0"
Start-Sleep -Seconds 2
ssh -o StrictHostKeyChecking=no ${admin}@${WORKER0IP} 'sudo sh ~/kubeadmjoin.sh'
Start-Sleep -Seconds 1
Write-Output "Adding node WORKER1"
ssh -o StrictHostKeyChecking=no ${admin}@${WORKER1IP} 'sudo sh ~/kubeadmjoin.sh'
Start-Sleep -Seconds 1
Write-Output "Adding node WORKER2"
ssh -o StrictHostKeyChecking=no ${admin}@${WORKER2IP} 'sudo sh ~/kubeadmjoin.sh'

########################
# AZURE ARC ONBOARDING #
########################

# Register necessart resource providers on the subscription
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.ExtendedLocation

# Creating a service principal for login for Azure Arc onboarding
$sp=$(az ad sp create-for-rbac --name "onboardersp" --role Contributor --scopes /subscriptions/$subscriptionId/resourceGroups/$RG --sdk-auth --output json | ConvertFrom-Json)
Start-Sleep -Seconds 2

# Save the clientId, clientSecret, and tenantId
$clientId = $sp.clientId
$clientSecret = $sp.clientSecret
$tenantId = $sp.tenantId
Start-Sleep -Seconds 3

# Run prerequisites and onboarding commands within the master node
az vm run-command create --resource-group $RG --async-execution false --run-as-user $admin --script "sudo wget -O - https://raw.githubusercontent.com/marianleica/azrez/refs/heads/progress/pwshjobs/azvm-onboardingArc-runcommand.sh | bash -s -- $clientId $clientSecret $tenantId" --timeout-in-seconds 3600 --run-command-name "OnboardingToArc" --vm-name kube-master-1

#######################

Write-Output ""
Write-Output "Save aside the setup details:"
Write-Output "VM node kube-master-1 has ${MASTER1IP}"
Write-Output "VM node kube-worker-0 has ${WORKER0IP}"
Write-Output "VM node kube-worker-1 has ${WORKER1IP}"
Write-Output "VM node kube-worker-2 has ${WORKER2IP}"
Write-Output "The VM admin account is ${admin}"
Write-Output ""

Write-Output "The Kubernetes cluster should be created now and nodes joined."
Write-Output "The Azure Arc onboarding should be completed by now."
Write-Output "The ssh commands for the nodes are:"
Write-Output "ssh ${admin}@${MASTER1IP}"
Write-Output "ssh ${admin}@${WORKER0IP}"
Write-Output "ssh ${admin}@${WORKER1IP}"
Write-Output "ssh ${admin}@${WORKER2IP}"
Write-Output ""
Write-Output "Connect to the master node to start using the cluster."
Write-Output ""
Start-Sleep -Seconds 2
Read-Host "Press any key to continue..."
