#!/bin/bash
mkdir -p /etc/libvirt/qemu    2>/dev/null
mkdir -p /etc/libvirt/storage 2>/dev/null
mkdir -p /etc/libvirt/secrets 2>/dev/null
mkdir -p /var/run/libvirt     2>/dev/null
ln -sf /var/run/libvirt /var/run/libvirtd-dockerd

docker run -d\
  --name=libvirtd\
  --privileged \
  --restart=always\
  --net=host\
  --device /dev/kvm\
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw\
  --cap-add SYS_ADMIN\
  --cap-add SYS_NICE\
  --cap-add NET_ADMIN\
  -v /var/run/libvirtd-dockerd:/var/run/libvirt\
  -v /var/lib/libvirt:/var/lib/libvirt\
  -v /etc/libvirt/qemu:/etc/libvirt/qemu\
  -v /etc/libvirt/storage:/etc/libvirt/storage\
  -v /etc/libvirt/secrets:/etc/libvirt/secrets\
  armv8a/libvirtd
