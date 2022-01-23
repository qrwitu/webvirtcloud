#!/bin/bash
docker run --name webvirtcloud -d -p 80:80 -p 443:443 -p 6080:6080 armv8a/webvirtcloud
