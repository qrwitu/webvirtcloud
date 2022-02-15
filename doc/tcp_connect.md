## On Debian 10/11 Arm64

#### 1.Install support pkgs

```
apt-get install sasl2-bin
apt install libsasl2-modules
```

#### 2.Change config

- **cat /etc/libvirt/libvirtd.conf | egrep  -v ^$ | egrep  -v ^#**

```
listen_tls = 0
listen_tcp = 1
tcp_port = "16509"
listen_addr = "0.0.0.0"
auth_tcp = "sasl"
```

- **cat /etc/default/libvirtd | egrep  -v ^$ | egrep  -v ^#**

```
start_libvirtd="yes"
libvirtd_opts="-l"
```

- **cat /etc/sasl2/libvirt.conf | egrep  -v ^$ | egrep  -v ^#**

```
mech_list: digest-md5
```

#### 3.Set username and password

```
saslpasswd2 -a libvirt [username]
sasldblistusers2
[username]@[hostname]: userPassword
systemctl restart libvirtd
```

#### 4.Testing

```
virsh -c qemu+tcp://localhost/system nodeinfo
Please enter your authentication name: [username]@[hostname]
Please enter your password: userPassword
CPU model:           aarch64
CPU(s):              X
CPU socket(s):       X
Core(s) per socket:  X
Thread(s) per core:  X
NUMA cell(s):        X
Memory size:         X KiB
```
