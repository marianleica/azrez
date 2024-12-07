Write-Output "Creating an Azure VM running Ubuntu2204"
Start-Sleep -Seconds 1

# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario="azvm-ubuntu2204ssh"
$suffix=$(Get-Random -Minimum 10000 -Maximum 99999)
#suffix=$((10000 + RANDOM % 99999))
$RG="azrez"
$location="uksouth"
$VM="azvm-ubuntu-${suffix}"
$image="Ubuntu2204"

# Generating a random string to use as password
$userName = "azrez"
#$randompass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 30 | ForEach-Object {[char]$_})
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

# Create Ubuntu VM
# New-AzVm -ResourceGroupName $RG -Name $vmName -Location $location -Image $image -VirtualNetworkName "myVnet-${suffix}" -SubnetName "vmsubnet" -SecurityGroupName "vmNSG" -PublicIpAddressName $publicIp -OpenPorts 80,22 -GenerateSshKey
az vm create -n $VM -g $RG --image $image --generate-ssh-keys --admin-username $userName --size Standard_D2s_v3 --nsg-rule ssh --public-ip-sku Standard

Start-Sleep -Seconds 2
# This is the public IP address
# $vmip=$(az vm list-ip-addresses -g $rg -n $vmName --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)
$vmip=$(az vm list-ip-addresses -g $RG -n $VM --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" --output tsv)

Start-Sleep -Seconds 1
Write-Output ""
Write-Output "The public IP address allocated to VM ${VM} is ${vmip}"
Write-Output "Save aside your credentials"
Write-Output "The admin user name is: ${userName}"
Write-Output ""
Start-Sleep -Seconds 1

# Logging
Write-Output "${timestamp}; {${scenario}; RG: ${RG}; Location: ${location}; ResType: VM; ResName: ${VM}; PublicIP: ${vmip}; Admin: azrez}" >> C:\azrez\azrez.log

# Look for user input to perform ssh connection right now
$userinput = Read-Host -Prompt "Do you want to connect to ${VM} via ssh now? (y/n)"
if ($userinput -eq "y"){az ssh vm -g $RG -n $VM --local-user $userName}
else {Write-Output "Save the command for later: az ssh vm -g ${RG} -n ${VM} --local-user ${userName}"}

# the script doesn't proceed with the config after the ssh session is started
# we should put all lines below before the ssh prompt
# the procedure should be with az vm invoke command to the respective vm

# Add Docker's official GPG key:
echo "Adding the Docker's official GPG"
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "Adding the repository to the apt sources"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Install the docker packages
echo "Now installing the docker packages"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Run the test hello world
echo "Let's test it with a quick hello-wolrd container"
sudo docker run hello-world
