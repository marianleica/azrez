# Deploy application and NodePort services
kubectl create deploy tstapp1 --image=nginx:alpine --replicas 2 --port 80
kubectl create deploy tstapp2 --image=nginx --replicas 2 --port 80

kubectl expose deploy tstapp1 --type NodePort --port 80
kubectl expose deploy tstapp2 --type NodePort --port 80

# Deploy ILB for the NodePort services
# Need to integrate these somehow

kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: tstapp1-ilb
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-ipv4: 10.240.0.50
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30557
  selector:
    app: tstapp1
---
apiVersion: v1
kind: Service
metadata:
  name: tstapp2-ilb
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-ipv4: 10.240.0.51
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30558
  selector:
    app: tstapp2
EOF
