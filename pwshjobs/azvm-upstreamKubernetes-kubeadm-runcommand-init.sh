# Initial Ubuntu packages update and upgrade
sudo apt update && sudo apt upgrade -y

# Disable all swap spaces
sudo swapoff -a

# Comment out swap partition from fstab
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Load the necessary kernel modules for K8s
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl parameters
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install essential packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Download and install Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt install -y containerd.io

# Install dontainerd and configure it
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# Add K8s repo and install the necessary tools for management 
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Provide example
echo "(!)"
echo "Copy this information from the kubeadm init output to run on worker nodes be able to add them:"
echo "Below is an example, your output has an unique token"
echo "kubeadm join 192.168.0.4:6443 --token jjzu4e.xsrs0fknopxaqhhx --discovery-token-ca-cert-hash sha256:823ff397ce70aa7b3d99c2434bd07ddde27c0bf0c14d9c34eea1069ae9a44eb4"
echo ""

# Logging kubeadm output 
sleep 1
sudo kubeadm init > ~/kubeadminit.log

sleep 15

# Automatically move the config file to the user home folder 
echo "Taking the kubeconfig file to be able to run kubectl commands:" 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Apply calico for network management 
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# to select the kubeadm join command
cat ~/kubeadminit.log | grep -i "kubeadm join" -A1 > ~/kubeadmjoin.sh
