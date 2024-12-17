# Setting variables
$timestamp = $(Get-Date -Format "yyyy/MM/dd-HH:mm UTCK")
$scenario = "upstreamKubernetes-infra"
$suffix=$(Get-Random -Minimum 100 -Maximum 999)
$suffix2=$(Get-Random -Minimum 10 -Maximum 99)
$RG="azrez"
$vnet="kubeadm"
$subnet="kube"
$admin="adm${suffix}"
$loc="uksouth"
