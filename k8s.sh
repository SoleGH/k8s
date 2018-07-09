#!/bin/bash

KUBE_VERSION=v1.11.0
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.2.18
DNS_VERSION=1.1.3

GCR_URL=gcr.io/google_containers
INLAND_URL=anjia0532
MY_URL=registry.cn-hangzhou.aliyuncs.com/yangbf

images=(kube-proxy-amd64:${KUBE_VERSION}
kube-scheduler-amd64:${KUBE_VERSION}
kube-controller-manager-amd64:${KUBE_VERSION}
kube-apiserver-amd64:${KUBE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
etcd-amd64:${ETCD_VERSION}
coredns:${DNS_VERSION}
#k8s-dns-sidecar-amd64:${DNS_VERSION}
#k8s-dns-kube-dns-amd64:${DNS_VERSION}
#k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION})

docker login
for imageName in ${images[@]} ; do
  docker pull $INLAND_URL/$imageName
  docker tag $INLAND_URL/$imageName $GCR_URL/$imageName
  
  docker push $MY_URL/$imageName
  # delete useless images
  docker rmi $MY_URL/$imageName
  docker rmi $INLAND_URL/$imageName
done
