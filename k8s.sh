#!/bin/bash

KUBE_VERSION=v1.11.0
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.2.18
DNS_VERSION=1.1.3

GCR_URL=gcr.io
INLAND_URL=
MY_ALI_URL=registry.cn-hangzhou.aliyuncs.com/yangbf
MY_DOCKER_URL=soleyang

SOURCE_URL=$MY_DOCKER_URL
AIM_URL=$MY_ALI_URL

log_url='--username=997021985@qq.com registry.cn-hangzhou.aliyuncs.com'
# log_url = soleyang
echo $log_url
docker login $log_url

images=(
kube-proxy-amd64:${KUBE_VERSION}
kube-scheduler-amd64:${KUBE_VERSION}
kube-controller-manager-amd64:${KUBE_VERSION}
kube-apiserver-amd64:${KUBE_VERSION}
pause-amd64:${KUBE_PAUSE_VERSION}
etcd-amd64:${ETCD_VERSION}
coredns:${DNS_VERSION}
#k8s-dns-sidecar-amd64:${DNS_VERSION}
#k8s-dns-kube-dns-amd64:${DNS_VERSION}
#k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION}
)

for imageName in ${images[@]} 
do
  docker pull $SOURCE_URL/$imageName
  docker tag $SOURCE_URL/$imageName $GCR_URL/$imageName
  docker tag $SOURCE_URL/$imageName $AIM_URL/$imageName
  
  docker push $AIM_URL/$imageName
  # delete useless images
  docker rmi $AIM_URL/$imageName
  docker rmi $SOURCE_URL/$imageName
done
