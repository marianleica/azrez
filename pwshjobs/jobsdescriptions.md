### Administrative tasks
- `azsetup` -- performs azlogin, good for first-time setup, chaning users or subscriptions
- `azgroup-delete` -- performs delete of the 'azrez' resource group and all resources within

### Azure VM scenarios
- `azvm-ubuntu2204ssh` -- runs VM create with Ubuntu2204, with option to ssh into the VM at the end via the public IP address
- `azvm-windows11` -- runs VM create with Windows 11, with option to RDP into the VM at the end via the public IP address 
- `azvm-windowsserver2022` -- runs VM create with Windows Server 2022, with option to RDP into the VM at the end via the public IP address

### ACT scenarios
- `azaks-public-kubenet-lb` -- runs AKS create with public API, kubenet CNI, and the LoadBalancer outbound type 
- `azaks-public-kubenet-udr` -- runs AKS create with public API, kubenet CNI, and UDR outbound type routing to an Azure Firewall
- `azaks-public-azurecni-lb` -- runs AKS create with public API, Azure CNI, and the LoadBalancer outbound type 
- `azaks-public-azurecni-udr` -- runs AKS create with public API, Azure CNI, and UDR outbound type routing to an Azure Firewall
- `azaksKubenetUdrFw` -- runs AKS create with public API, kubenet CNI, and UDR outbound type routing to an Azure Firewall
- `azaksKubenetUdrFw-private` -- runs AKS create with private API, kubenet CNI, and UDR outbound type routing to an Azure Firewall
- `aksKubenetUdrFw-privateJB` -- runs AKS create with private API, kubenet CNI, and UDR outbound type routing to an Azure Firewall, plus a JumpBox Ubuntu2204 VM in the same VNET from which to access the private cluster.
- `azaks-private-azurecni-lb-jb` -- runs AKS create with private API, Azure CNI, and the LoadBalancer outbound type, plus a JumpBox Ubuntu2204 VM in the same VNET from which to access the private cluster.
- `azaks-windowsnp` -- runs AKS create with public API, Azure CNI, the LoadBalancer outbound type, a WindowsProfile configured, and a Windows Server 2022 node-pool
- `azaksAzureCniUdrFw` -- runs AKS create with public API, Azure CNI, and UDR outbound type routing to an Azure Firewall
- `azaksAzureCniUdrFw-private` -- runs AKS create with private API, Azure CNI, and UDR outbound type routing to an Azure Firewall

### ARC scenarios
- `aksArc` -- runs AKS create in basic configuration and connects the cluster to Azure Arc-enabled Kubernetes
- `aksArcAppServiceExt` -- runs `aksArc` on which it installs the AppService Extension 
- `aksArcAppServiceExtWebApp` -- runs `aksArcAppServiceExt` on which it deploys an AppService webapp resource and showcases how to deploy another one
- `upstreamKubernetes-infra` -- it creates the Azure IaaS with Ubuntu2204 VM nodes, 2 control plane nodes and 2 worker nodes, suitable for Kubernetes configuration via kubeadm  
