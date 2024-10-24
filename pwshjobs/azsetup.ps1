Write-Output "Running initial setup for Windows development environment"

# If all is PowerShell-based we might not need az cli
# Start-Sleep -Seconds 2
# Write-Output "Installing AZCLI latest version"
# curl -L https://aka.ms/InstallAzureCli | bash
# Start-Sleep -Seconds 1
# Write-Output "Confirming AZCLI is installed"
# az version

Start-Sleep -Seconds 1

Write-Output "Install winget, if not present"
# Install winget
$progressPreference = 'silentlyContinue'
Write-Information "Downloading WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

Start-Sleep -Seconds 1

Write-Output "Install Az CLI"
# Install az cli on windows
winget install -e --id Microsoft.AzureCLI

Start-Sleep -Seconds 1

# Write-Output "Installing Az PowerShell Module"
# Install Az PowerShell module
# Install-Module -Name PowerShellGet -Force
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Install-Module -Name Az -Repository PSGallery -Force -AllowClobber
# Update-Module -Name Az -Force

# Now login to Azure and set subscription
Start-Sleep -Seconds 1
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
