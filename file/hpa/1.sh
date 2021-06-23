kubectl  delete hpa tom-deployment
kubectl autoscale deployment tom-deployment --cpu-percent=400 --min=1 --max=10
