##  kubelet 开启认证，不允许匿名
--authentication-token-webhook=true 
--authorization-mode=Webhook 
--anonymous-auth=false 
##
--cluster-dns=10.254.0.10 
--cluster-domain=cluster.local. 
--resolv-conf=/etc/resolv.conf
--enable-server=true 
--enable-debugging-handlers=true 
--fail-swap-on=false 
--kubeconfig=/var/lib/kubelet/kubeconfig 
--runtime-cgroups=/systemd/system.slice 
--kubelet-cgroups=/systemd/system.slice 
--cgroup-driver=systemd 
###
--tls-cert-file=/etc/kubernetes/ssl/vpnB.pem 
--tls-private-key-file=/etc/kubernetes/ssl/vpnB-key.pem 
--client-ca-file=/etc/kubernetes/ssl/ca.pem
