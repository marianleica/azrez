Write-Output "Running initial setup for Windows development environment"

$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "azsetup"

Start-Sleep -Seconds 1

# Write-Output "Install Az CLI"
# Install az cli on windows
#$ProgressPreference = 'SilentlyContinue'
#Invoke-WebRequest -Uri https://aka.ms/installazurecliwindowsx64 -OutFile .\AzureCLI.msi
#.\AzureCLI.msi

#Start-Sleep -Seconds 1

# Write-Output "Installing Az PowerShell Module"
# Install Az PowerShell module
# Install-Module -Name PowerShellGet -Force
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Install-Module -Name Az -Repository PSGallery -Force -AllowClobber
# Update-Module -Name Az -Force

# Now login to Azure and set subscription
#Start-Sleep -Seconds 1
Write-Output "Your browser will open now. Please login to Azure:"
az login
Write-Output ""

Start-Sleep -Seconds 1
# Write-Output "These are the subscriptions associated with your account:"
    # Get-AzContext | fl *Name,Subscription,SubscriptionName,Account*
# Write-Output ""
# Start-Sleep -Seconds 1
# $subscriptionid = Read-Host "Please choose your subscription from the list above and paste it here: "
# Write-Output ""
# Write-Output "Setting the subscription $subscriptionid for use"
# Set-AzContext -Subscription $subscriptionid

