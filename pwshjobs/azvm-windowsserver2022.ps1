Write-Output "Creating Windows Server 2022 Azure Virtual Machine"
Start-Sleep -Seconds 1

# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario="azvm-windowsserver2022"
$suffix=$(Get-Random -Minimum 1000 -Maximum 9999)
$RG="azrez"
$location="uksouth"
$VM="azvm-win22-${suffix}"
$image='MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest'
$publicIp="winsrv22IP-${suffix}"

# Generating a random string to use as password
$user = "azrez"
$randompass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 30 | ForEach-Object {[char]$_})
#Read more: https://www.sharepointdiary.com/2020/04/powershell-generate-random-password.html#ixzz8XiwccFos
#$Password = ConvertTo-SecureString $randompass -AsPlainText -Force
#$psCred = New-Object System.Management.Automation.PSCredential($UserName, $Password)

Write-Output "Creating virtual machine ${VM} in resource group ${RG} in location ${location}"
Start-Sleep -Seconds 1
Write-Output ""

Write-Output "The Resource Group:"
# Create RG
az group create -n $RG -l $location
Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The virtual machine ${VM}:"

# Create Windows Server 2022
# New-AzVm -ResourceGroupName $rg -Name $vmName -Location $location -Image $image -VirtualNetworkName "myVnet-${suffix}" -SubnetName "vmsubnet" -SecurityGroupName "vmNSG" -PublicIpAddressName $publicIp -OpenPorts 80,3389
az vm create -g $RG -n $VM --image $image --admin-user $user --admin-password $randompass --public-ip-sku Standard --nsg NSG4VM --nsg-rule RDP --size Standard_D2s_v3

Start-Sleep -Seconds 2
# This is the public IP address
$vmip=$(az vm list-ip-addresses -g $RG -n $VM --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
#$vmip=$(Get-AzPublicIpAddress -Name $publicIp -ResourceGroupName $rg)

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The public IP address allocated to VM ${VM} is ${vmip}"
Write-Output "The admin user name is: ${user}"
Write-Output "The unique password is: ${randompass}"
Write-Output ""
Start-Sleep -Seconds 1

# Logging
if (Test-Path -Path "C:\" -ErrorAction SilentlyContinue) {
Write-Output "${timestamp}; {${scenario}; RG: ${RG}; Location: ${location}; ResType: VM; ResName: ${VM}; PublicIP: ${vmip}; Admin: azrez}" >> C:\azrez\azrez.log
} else {
Write-Output "C drive not found, skipping logging."
}

# Look for user input to perform RDP connection right now
$userinput = Read-Host -Prompt "Do you want to connect to ${VM} via RDP now? (y/n)"
if ($userinput -eq "y"){Get-AzRemoteDesktopFile -ResourceGroupName $RG -Name $VM -Launch}
else {Write-Output "Save the command for later: Get-AzRemoteDesktopFile -ResourceGroupName $RG -Name $VM -Launch"}
