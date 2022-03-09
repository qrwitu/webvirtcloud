#!/bin/bash
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
  -v /var/run/libvirt:/var/run/libvirt\
  -v /var/lib/libvirt:/var/lib/libvirt\
  armv8a/libvirtd
