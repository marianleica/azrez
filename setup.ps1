# Download the repo contents to C:\azrez and expand the archive
Start-BitsTransfer -Source "https://github.com/marianleica/azrez/archive/refs/heads/public.zip" -Destination "C:\azrez.zip"
Expand-Archive -Path "C:\azrez.zip" -DestinationPath "C:\" -Force
# Edit the path name and remove the initial compressed file
mv C:\azrez-public C:\azrez\
rmdir C:\azrez.zip
# Add to environment variables
$env:Path += "C:\azrez\"
