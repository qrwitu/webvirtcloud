FROM ubuntu:20.04

# install qemu-kvm, libvirt daemon and required dependencies
RUN apt-get update -y && apt upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-system-arm qemu-efi-aarch64 libvirt-daemon-system libvirt-clients bridge-utils vim bash && \
    apt-get autoclean && \
    apt-get autoremove

# copy configurations
COPY libvirtd.conf /etc/libvirt/libvirtd.conf
COPY qemu.conf /etc/libvirt/qemu.conf

# copy startup script
COPY startup.sh /

ENTRYPOINT [ "/startup.sh" ]
