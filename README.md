## Prerequisites:

- For Windows Client & Server, have the .NET framework runtime or SDK installed on your system prior to running AZREZ. Reference: https://learn.microsoft.com/en-us/dotnet/core/install/windows

To install .NET with Powershell, follow the steps in: https://learn.microsoft.com/en-us/dotnet/core/install/windows#install-with-powershell

Or run the following cmdlets in PowerShell:

```
Start-BitsTransfer -Source "https://dot.net/v1/dotnet-install.ps1" -Destination "$HOME/dotnet-install"

cd "$HOME"

.\dotnet-install.ps1 # This will install the .NET SDK
```

## Getting AZREZ locally

#### Getting AZREZ locally via the provided PowerShell script:
setup.ps1
https://raw.githubusercontent.com/marianleica/azrez/refs/heads/public/setup.ps1

#### Getting AZREZ ready on Windows Client manually using PowerShell cmdlets:

```
Start-BitsTransfer -Source "https://github.com/marianleica/azrez/archive/refs/heads/public.zip" -Destination "C:\azrez.zip"
Expand-Archive -Path "C:\azrez.zip" -DestinationPath "C:\" -Force
mv C:\azrez-public C:\azrez\
rmdir C:\azrez.zip
$env:Path += "C:\azrez\"
```

## Limitations of the current release

- The AZREZ tool is supported only for Windows OS on Windows Client and Server versions supported by Microsoft
- The AZREZ tool only works in the following directory path "C:\azrez" with the backend scripts on "C:\azrez\pwshjobs"
- All resources are by default using the 'azrez' resource group and the 'uksouth' Azure region. The job scripts are accessible for whoever wants to use a different resource group name or Azure region, as well as any alternate configurations.

## Feedback and feature requests

- For any issues or questions about the tool,. please submit a github issue with the details on the repository page.
- For any feature requests or changes, please submit a github issue with the details on the repository page.

## Release notes

#### v1.05
