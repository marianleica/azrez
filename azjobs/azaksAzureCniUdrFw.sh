# Source: https://learn.microsoft.com/en-us/azure/aks/limit-egress-traffic?tabs=aks-with-system-assigned-identities

echo "Grab a coffee, this can take several minutes to complete.."

PREFIX="aks-azurecni-udr"
SUFFIX=$((10000 + RANDOM % 99999))
RG="azrez"
LOC="uksouth"
PLUGIN=azure
AKSNAME="aks-azurecni-udr_${SUFFIX}"
VNET_NAME="${PREFIX}-vnet-${SUFFIX}"
AKSSUBNET_NAME="aks-subnet"
# DO NOT CHANGE FWSUBNET_NAME - This is currently a requirement for Azure Firewall.
FWSUBNET_NAME="AzureFirewallSubnet"
FWNAME="${PREFIX}-fw"
FWPUBLICIP_NAME="${PREFIX}-fwpublicip-${SUFFIX}"
FWIPCONFIG_NAME="${PREFIX}-fwconfig-${SUFFIX}"
FWROUTE_TABLE_NAME="${PREFIX}-fwrt-${SUFFIX}"
FWROUTE_NAME="${PREFIX}-fwr-${SUFFIX}"
FWROUTE_NAME_INTERNET="${PREFIX}-fwinternet$SUFFIX}"

echo "Creating resource group $RG in $LOC:"
# Creating resource group
az group create --name $RG --location $LOC

sleep 1
echo ""
echo "Creating VNET with subnet $AKSSUBNET_NAME:"
# Dedicated virtual network with AKS subnet
az network vnet create --resource-group $RG --name $VNET_NAME --location $LOC --address-prefixes 10.42.0.0/16 --subnet-name $AKSSUBNET_NAME --subnet-prefix 10.42.1.0/24

sleep 2
echo ""
echo "Creating dedicated subnet for Azure Firewal with fixed name:"
# Dedicated subnet for Azure Firewall (Firewall name can't be changed)
az network vnet subnet create --resource-group $RG --vnet-name $VNET_NAME --name $FWSUBNET_NAME --address-prefix 10.42.2.0/24

sleep 1
echo ""
echo "Creating standard SKU public IP resource:"
# Create standard SKU publip IP resource
az network public-ip create -g $RG -n $FWPUBLICIP_NAME -l $LOC --sku "Standard"

sleep 1
echo ""
echo "We'll need the azure-firewall az cli extension:"
# Register the Azure Firewall CLI extension
az extension add --name azure-firewall

sleep 1
echo ""
echo "Creating Azure Firewall with DNS proxy enabled:"
# Create Azure Firewall and enable DNS proxy
az network firewall create -g $RG -n $FWNAME -l $LOC --enable-dns-proxy true

sleep 1
echo ""
echo "Creating Azure Firewall IP configuration:"
# Create Azure Firewall IP configuration
az network firewall ip-config create -g $RG -f $FWNAME -n $FWIPCONFIG_NAME --public-ip-address $FWPUBLICIP_NAME --vnet-name $VNET_NAME

sleep 1
echo ""
FWPUBLIC_IP=$(az network public-ip show -g $RG -n $FWPUBLICIP_NAME --query "ipAddress" -o tsv)
FWPRIVATE_IP=$(az network firewall show -g $RG -n $FWNAME --query "ipConfigurations[0].privateIPAddress" -o tsv)

echo "Creating an empty route table and routes:"
# Create empty route table
az network route-table create -g $RG -l $LOC --name $FWROUTE_TABLE_NAME

sleep 1
# Create routes for the route table
az network route-table route create -g $RG --name $FWROUTE_NAME --route-table-name $FWROUTE_TABLE_NAME --address-prefix 0.0.0.0/0 --next-hop-type VirtualAppliance --next-hop-ip-address $FWPRIVATE_IP
az network route-table route create -g $RG --name $FWROUTE_NAME_INTERNET --route-table-name $FWROUTE_TABLE_NAME --address-prefix $FWPUBLIC_IP/32 --next-hop-type Internet

sleep 1
echo ""
echo "Adding Firewall network and application rules specific for AKS"
# Adding firewall network rules
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apiudp' --protocols 'UDP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 1194 --action allow --priority 100
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'apitcp' --protocols 'TCP' --source-addresses '*' --destination-addresses "AzureCloud.$LOC" --destination-ports 9000
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'time' --protocols 'UDP' --source-addresses '*' --destination-fqdns 'ntp.ubuntu.com' --destination-ports 123
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'ghcr' --protocols 'TCP' --source-addresses '*' --destination-fqdns ghcr.io pkg-containers.githubusercontent.com --destination-ports '443'
az network firewall network-rule create -g $RG -f $FWNAME --collection-name 'aksfwnr' -n 'docker' --protocols 'TCP' --source-addresses '*' --destination-fqdns docker.io registry-1.docker.io production.cloudflare.docker.com --destination-ports '443'

sleep 1
echo ""
# Adding firewall application rules
az network firewall application-rule create -g $RG -f $FWNAME --collection-name 'aksfwar' -n 'fqdn' --source-addresses '*' --protocols 'http=80' 'https=443' --fqdn-tags "AzureKubernetesService" --action allow --priority 100

sleep 1
echo ""
# Associate the route table to AKS subnet
az network vnet subnet update -g $RG --vnet-name $VNET_NAME --name $AKSSUBNET_NAME --route-table $FWROUTE_TABLE_NAME

sleep 1
# Deploy AKS cluster with system-assigned identity
SUBNETID=$(az network vnet subnet show -g $RG --vnet-name $VNET_NAME --name $AKSSUBNET_NAME --query id -o tsv)

echo ""
echo "Creating AKS cluster with azurecni and UserDefinedRouting outbound type:"
az aks create -g $RG -n $AKSNAME -l $LOC --node-count 1 --network-plugin azure --outbound-type userDefinedRouting --vnet-subnet-id $SUBNETID --api-server-authorized-ip-ranges $FWPUBLIC_IP

sleep 1
echo "To be able to connect to the cluster we are adding your IP address to the Authorized IP Ranges:"
# Retrieve your IP address and add it to approved range
CURRENT_IP=$(dig @resolver1.opendns.com ANY myip.opendns.com +short)

# Avoiding the Authorized IP ranges setting
#
# sleep 1
# echo "Your IP address should be $CURRENT_IP"
# echo ""
# sleep 1
# az aks update -g $RG -n $AKSNAME --api-server-authorized-ip-ranges $CURRENT_IP

# Issue alert
# It seems that the IP address is correct and that it's found and applied correctly,
# However I don't get access to the cluster API
# Temporary workaround till I figure out why
az aks update -g $RG -n $AKSNAME --api-server-authorized-ip-ranges 0.0.0.0/0

echo ""
echo "Connecting to the AKS cluster:"
# Connect to the cluster
az aks get-credentials -g $RG -n $AKSNAME --admin --overwrite-existing

sleep 1
echo ""
echo "Deploying a sample workload for your testing, the aks-store-demo:"
echo "Find the yaml at: https://raw.githubusercontent.com/Azure-Samples/aks-store-demo/main/aks-store-quickstart.yaml"
echo ""
# Deploy public service workload to the cluster
kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/aks-store-demo/main/aks-store-quickstart.yaml

sleep 1
echo ""
# Allow inbound traffic through Azure Firewall
# Get service IP
SERVICE_IP=$(kubectl get svc store-front -o jsonpath='{.status.loadBalancer.ingress[*].ip}')

# Adding NAT rule
az network firewall nat-rule create --collection-name exampleset --destination-addresses $FWPUBLIC_IP --destination-ports 80 --firewall-name $FWNAME --name inboundrule --protocols Any --resource-group $RG --source-addresses '*' --translated-port 80 --action Dnat --priority 100 --translated-address $SERVICE_IP

# cleaning up
# az group delete -g $RG --yes --no-wait