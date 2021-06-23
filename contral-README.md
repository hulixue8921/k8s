--master=http://172.23.2.80:8080 
--service-account-private-key-file=/etc/kubernetes/serviceaccount.key
##If set, 
##this root certificate authority will be included in service account's token secret. 
##This must be a valid PEM-encoded CA bundle
--root-ca-file=/etc/kubernetes/ssl/ca.pem
