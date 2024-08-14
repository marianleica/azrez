Getting AZREZ ready on Windows Client manually using PowerShell cmdlets:

```
Start-BitsTransfer -Source "https://github.com/marianleica/azrez/archive/refs/heads/public.zip" -Destination "$HOME/azrez.zip"

Expand-Archive -Path "$HOME/azrez.zip" -DestinationPath "$HOME/azrez" -Force 

cd "$HOME\azrez\azrez-public" 

```
