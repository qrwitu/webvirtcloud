#!/bin/bash
docker build -f Dockerfile -t armv8a/libvirtd:20.4 .
docker tag armv8a/libvirtd:20.4 armv8a/libvirtd:arm64
docker tag armv8a/libvirtd:20.4 armv8a/libvirtd:latest