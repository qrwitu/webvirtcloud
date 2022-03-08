#### 1. cat /etc/libvirt/libvirtd.conf | egrep -v ^$ | egrep -v ^#

```
listen_tls = 0
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0777"
auth_unix_ro = "none"
auth_unix_rw = "none"
```

#### 2. Change :

```
unix_sock_rw_perms = "0777"
```

To:

```
unix_sock_rw_perms = "0777"
```

#### 3. The local sock is:

```
/var/run/libvirt/libvirt-sock
```
