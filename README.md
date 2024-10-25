## Prerequisites:

- For Windows Client & Server, have the .NET framework (minimum version .NET 8.0) runtime or SDK installed on your system prior to running AZREZ. Reference: https://learn.microsoft.com/en-us/dotnet/core/install/windows

To install .NET with Powershell, follow the steps in: https://learn.microsoft.com/en-us/dotnet/core/install/windows#install-with-powershell

Or **run the following cmdlets in elevated PowerShell to install .NET runtime 8.0.10**:

```
Start-BitsTransfer -Source "https://download.visualstudio.microsoft.com/download/pr/f55ed80e-ba58-4ac8-a2b3-f2227cd628de/6fabf1c613cf9386d14ddbaaca1a5eb8/dotnet-runtime-8.0.10-win-x64.exe" -Destination "$HOME/dotnet-runtime-8.0.10-win-x64.exe"

.\$HOME\dotnet-runtime-8.0.10-win-x64.exe
```

## Getting AZREZ locally

#### Getting AZREZ locally via the provided PowerShell script:
setup.ps1
https://raw.githubusercontent.com/marianleica/azrez/refs/heads/public/setup.ps1

#### Getting AZREZ ready on Windows Client manually using elevated PowerShell cmdlets:

```
# Download the repo contents to C:\azrez and expand the archive
Start-BitsTransfer -Source "https://github.com/marianleica/azrez/archive/refs/heads/public.zip" -Destination "C:\azrez.zip"
Expand-Archive -Path "C:\azrez.zip" -DestinationPath "C:\" -Force
# Edit the path name and remove the initial compressed file
mv C:\azrez-public C:\azrez\
rmdir C:\azrez.zip
# Add to environment variables
$env:Path += ";C:\azrez\"
```

## Limitations of the current release: v1.05

- The AZREZ tool is supported only for Windows OS on Windows Client versions supported by Microsoft
- The AZREZ tool only works in the following directory path "C:\azrez" with the backend scripts on "C:\azrez\pwshjobs"
- All resources are by default using the 'azrez' resource group and the 'uksouth' Azure region. The job scripts are accessible for whoever wants to use a different resource group name or Azure region, as well as any alternate configurations.
- The command `$env:Path += ";C:\azrez\"` only sets env variable in the current terminal session. Workaround for permanent variable is to manually add C:\azrez\ to the Path environment variables in Advanced System Settings

## Feedback and feature requests

- For any issues or questions about the tool,. please submit a github issue with the details on the repository page.
- For any feature requests or changes, please submit a github issue with the details on the repository page.

## Release notes

#### v1.05
