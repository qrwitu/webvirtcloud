#!/bin/bash
docker run \
--name webvirtcloud \
--restart=always \
-d --net host \
-v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock \
armv8a/webvirtcloud
