## Prerequisites:

1) Have a Windows Client machine on which you have the .NET framework (minimum .NET 8.0) runtime or SDK installed on your system prior to running AZREZ.

**To install .NET runtime 8.0.10 via elevated PowerShell**:

```
Start-BitsTransfer -Source "https://download.visualstudio.microsoft.com/download/pr/f55ed80e-ba58-4ac8-a2b3-f2227cd628de/6fabf1c613cf9386d14ddbaaca1a5eb8/dotnet-runtime-8.0.10-win-x64.exe" -Destination "$HOME/dotnet-runtime-8.0.10-win-x64.exe"
cd $HOME
.\dotnet-runtime-8.0.10-win-x64.exe

```
Restart the PowerShell console to continue.

2) Have Azure CLI (azcli) installed on your machine

**To install Azure CLI via elevated PowerShell**:
```
# Install az cli on windows
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindowsx64 -OutFile .\AzureCLI.msi
.\AzureCLI.msi

```
Restart the PowerShell console to continue.

## Get AZREZ locally

#### Get AZREZ ready on Windows Client using elevated PowerShell cmdlets:

```
# In case of any errors, retry running the commands
# Remove the package if it already exists
Remove-Item -Path C:\azrez\ -Recurse
# Download the repo contents to C:\azrez and expand the archive
Start-BitsTransfer -Source "https://github.com/marianleica/azrez/archive/refs/heads/public.zip" -Destination "C:\azrez.zip"
Expand-Archive -Path "C:\azrez.zip" -DestinationPath "C:\" -Force
# Edit the path name and remove the initial compressed file
mv C:\azrez-public C:\azrez\
rmdir C:\azrez.zip
# Add to environment variables for the current PS session only
$env:Path += ";C:\azrez\"

```

Also available as: `setup.ps1` -> https://raw.githubusercontent.com/marianleica/azrez/refs/heads/public/setup.ps1

Then input `azrez` to the console to start using the tool.

## Limitations of the current release: v1.06

- The AZREZ tool is supported only for Windows OS on Windows Client versions supported by Microsoft
- The AZREZ tool only works in the following directory path "C:\azrez" with the backend scripts on "C:\azrez\pwshjobs"
- All resources are by default using the 'azrez' resource group and the 'uksouth' Azure region. The job scripts are accessible for whoever wants to use a different resource group name or Azure region, as well as any alternate configurations.
- The command `$env:Path += ";C:\azrez\"` only sets env variable in the current terminal session. Workaround for permanent variable is to manually add C:\azrez\ to the Path environment variables in Advanced System Settings

## Feedback and feature requests

- For any issues or questions about the tool, please submit a new github issue on the repository page with a detailed description.
- For any feature requests or changes, please submit a github issue with the details on the repository page.

## Release notes

#### v1.06
- Added new scenarios: AKS node pools, private AKS cluster with Jumpbox VM, UDR outbound AKS private cluster with Jumpbox VM, Azure IaaS build setup ready for configuring kubeadm cluster
- AZ CLI is now a prerequisite and the az setup function (input 1) performs Azure Login

#### v1.05


