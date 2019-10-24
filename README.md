# k8s

前提准备
1、准备好 etcd 服务
2、master 、node 为:centos7  修改hostname ,修改selinux , master 中/etc/hosts 添加各个node 

安装：
master:
   执行 ./k8s.sh -etcd_host $etcdip -bincode_dir .  -mode master  -master_host $masterip
   $etcdip : etcd 服务器地址
   $masterip: master服务地址
   bincode_dir:  编译好k8s的二进制代码路径 （k8s.tar.gz）

node:
  执行 ./k8s.sh -etcd_host $etcdip -bincode_dir .  -mode node -master_host $masterip -node_host $nodeip
   $etcdip : etcd 服务器地址
   $masterip: master服务地址
   bincode_dir:  编译好k8s的二进制代码路径 （k8s.tar.gz）
   $nodeip:  node服务ip地址
   
 修改master 、node iptables
 master ：需要对集群里的node 开放8080 、6443
 node :需要对集群里的node 开放：tcp:10250 udp:8285  , 另外：forward 要 开放
