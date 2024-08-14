### Prerequisites:

- For Windows Client & Server, have the .NET framework runtime or SDK installed on your system prior to running AZREZ.

Reference: https://learn.microsoft.com/en-us/dotnet/core/install/windows

To install .NET with Powershell, follow the steps in: https://learn.microsoft.com/en-us/dotnet/core/install/windows#install-with-powershell

Or run the following cmdlets in PowerShell:

```
Start-BitsTransfer -Source "https://dot.net/v1/dotnet-install.ps1" -Destination "$HOME/dotnet-install"

cd "$HOME"

.\dotnet-install.ps1 # This will install the .NET SDK

```

Getting AZREZ ready on Windows Client manually using PowerShell cmdlets:

```
Start-BitsTransfer -Source "https://github.com/marianleica/azrez/archive/refs/heads/public.zip" -Destination "$HOME/azrez.zip"

Expand-Archive -Path "$HOME/azrez.zip" -DestinationPath "$HOME/azrez" -Force 

cd "$HOME\azrez\azrez-public" 

```
