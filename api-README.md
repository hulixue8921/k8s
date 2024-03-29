/usr/bin/kube-apiserver 
--etcd-servers=http://172.23.2.80:2379 
--insecure-bind-address=0.0.0.0 
--insecure-port=8080 
--service-cluster-ip-range=10.254.0.0/16 
--admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota 
--logtostderr=false
##日志参数
--log-dir=/var/log/kubernets/apiserver
##日志级别   
--v=7  
##
##开启聚合功能，自定义api
--requestheader-allowed-names=aggregator 
--requestheader-extra-headers-prefix=X-Remote-Extra- 
--requestheader-group-headers=X-Remote-Group 
--requestheader-username-headers=X-Remote-User 
--requestheader-client-ca-file=/etc/kubernetes/ssl/ca.pem 
--enable-aggregator-routing=true 
--proxy-client-cert-file=/etc/kubernetes/ssl/aggregator.pem 
--proxy-client-key-file=/etc/kubernetes/ssl/aggregator-key.pem
###
###api->kubelet api的身份认证(api以证书中cn的身份去访问，需要RBAC),kubectl exec  
--kubelet-client-certificate=/etc/kubernetes/ssl/kube-apiserver-kubelet-client.crt 
--kubelet-client-key=/etc/kubernetes/ssl/kube-apiserver-kubelet-client.key
###
--tls-cert-file=/etc/kubernetes/ssl/apiserver.pem 
--tls-private-key-file=/etc/kubernetes/ssl/apiserver-key.pem 
--client-ca-file=/etc/kubernetes/ssl/ca.pem 
--service-account-key-file=/etc/kubernetes/serviceaccount.key 
--allow-privileged=true 
--runtime-config=batch/v2alpha1=true 
--authorization-mode=RBAC
