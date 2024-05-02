Write-Output "Running initial setup for Windows development environment"

# If all is PowerShell-based we might not need az cli
# Start-Sleep -Seconds 2
# Write-Output "Installing AZCLI latest version"
# curl -L https://aka.ms/InstallAzureCli | bash
# Start-Sleep -Seconds 1
# Write-Output "Confirming AZCLI is installed"
# az version

Start-Sleep -Seconds 1

# Install az cli on windows
winget install -e --id Microsoft.AzureCLI

# Install Az PowerShell module
Install-Module -Name PowerShellGet -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Repository PSGallery -Force
Update-Module -Name Az -Force

# Now login to Azure and set subscription
Start-Sleep -Seconds 1
Write-Output "Please login to Azure:"
Connect-AzAccount
Write-Output ""
Write-Output "These are the subscriptions associated with your account:"
Get-AzContext | fl *Name,Subscription,SubscriptionName,Account*
Start-Sleep -Seconds 1
Write-Output ""
$subscriptionid = Read-Host "Please choose your subscription from the list above and paste it here: "
Write-Output ""
Write-Output "Setting the subscription $subscriptionid for use"
Set-AzContext -Subscription $subscriptionid
