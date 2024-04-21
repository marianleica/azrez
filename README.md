# Azure Resource Launcher (azrez)
Azure Resource Launcher (`azrez`) is a console application for Windows that aims to support those looking for quick deployments in Azure for learning and quicker repro troubleshooting.

## Supported operating systems

- **Support for Windows**: using the built-in PowerShell with minimum dependencies for Windows-based operating systems, just the AzModule, AZ CLI, and your Azure subscription account

## How to get it

### Cloning the repository:
Using git:
`git clone https://github.com/marianleica/azrez.git`

For more information, see:
https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository

### Using other console commands:

`Start-BitsTransfer https://github.com/marianleica/azrez/tree/main -Destination .

### Setting it as environment variable for easy access from the terminal

...

## Flows

There are 2 main flows you can choose from:
- **Basic**
- **Scenarios**

Here's a step-by-step description of its running flows:

(a) Once started, the `azrez` tool, in the current version v1.0, the user is asked for an initial setup which will be different based on the selected OS.

(b) Next, the user is shown the 2 flows to choose from: Basic or Scenarios
- **Basic** supports so far the creation of Azure Virtual Machines ("VM") or Azure Kubernetes Services ("AKS")
- **Scenarios** supports so far the creation of AKS public or private clusters, with kubenet or azurecni, in a UDR outbound type with Azure Firewall as a next hop

(d) Once the user selects the desired resource, the backend scripts will be deploying the resources in the "azrez" Resource Group in the "uksouth" region.
