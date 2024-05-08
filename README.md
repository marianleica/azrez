# Azure Resource Launcher (azrez)
Azure Resource Launcher (`azrez`) is a console application for Windows that aims to support those looking for quick deployments in Azure for learning and quicker repro troubleshooting.

## Supported operating systems

- **Support for Windows**: The initial sync requires the PowerShell AzModule installed, it prompts Azure Login, and it uses built-in PowerShell for all runs;
- **Support for Linux**: The initial sync grabs AZ CLI using curl, it prompts Azure login, and it uses AZ CLI for all runs;
- **Support for MacOS**: The initial sync grabs AZ CLI using brew, it prompts Azure login, and it uses AZ CLI for all runs.

## How to get it

### Cloning the repository:
Using git:
`git clone https://github.com/marianleica/azrez.git`

For more information, see:
https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository

### Or download it with native commands:

**For Windows:**

`Start-BitsTransfer https://github.com/marianleica/azrez/tree/main -Destination .`

<p>Add azrez to your environment variables:</p>

`code`

<p>Now you should be able to open it from any console</p>

e.g. open `CMD` or `PowerShell` and type `azrez`

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

### Basic flow

For Azure Virtual Machines ("VM"):
- Ubuntu2204 -> `Ubuntu2204`, `ubuntu2204`, or `ubuntu`
- Windows11 -> `Windows11`, `windows11`, or `windows`
- WindowsServer2022 -> `WindowsServer2022`, `windowsserver2022`, or `windowsserver`

For Azure Kubenretes Services ("AKS"), select networking options:
- Kubenet -> `Kubenet` or `kubenet`
  - LoadBalancer Outbound -> `LoadBalancer`, `loadbalancer`, or `lb`
  - UserDefinedRouting Outbound -> `UserdefinedRouting`, `userdefinedrouting`, or `udr`
- AzureCNI -> `AzureCNI` or `azurecni`
  - LoadBalancer Outbound -> `LoadBalancer`, `loadbalancer`, or `lb`
  - UserDeginedRouting Outbound -> `UserdefinedRouting`, `userdefinedrouting`, or `udr`

### Scenarios flow

(...)

