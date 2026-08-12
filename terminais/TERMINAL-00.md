root@vmi3487682:~# sudo apt-get update && sudo apt-get upgrade -y
Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease
Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease
Hit:3 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:4 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
root@vmi3487682:~# sudo apt-get install -y curl gnupg apt-transport-https ca-certificates
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
ca-certificates is already the newest version (20260601~22.04.1).
curl is already the newest version (7.81.0-1ubuntu1.25).
gnupg is already the newest version (2.2.27-3ubuntu2.5).
apt-transport-https is already the newest version (2.4.14).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
root@vmi3487682:~# sudo hostnamectl set-hostname eck-lab
root@vmi3487682:~# sudo swapoff -a
root@vmi3487682:~# pwd
/root
root@vmi3487682:~# sudo sed -i.bak '/\bswap\b/ s/^/#/' /etc/fstab
root@vmi3487682:~# free -h        # a linha "Swap" deve mostrar 0B
               total        used        free      shared  buff/cache   available
Mem:            23Gi       242Mi        22Gi       1.0Mi       719Mi        22Gi
Swap:             0B          0B          0B
root@vmi3487682:~# sudo tee /etc/modules-load.d/k8s.conf <<'EOF'
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
overlay
br_netfilter
root@vmi3487682:~# lsmod | grep -E 'overlay|br_netfilter'    # ambos devem aparecer
br_netfilter           32768  0
bridge                311296  1 br_netfilter
overlay               151552  0
root@vmi3487682:~# sudo tee /etc/sysctl.d/99-eck.conf <<'EOF'
# Rede exigida pelo Kubernetes
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
# Exigência do Elasticsearch (ES 8.16+/9.x)
vm.max_map_count                    = 1048576
EOF
# Rede exigida pelo Kubernetes
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
# Exigência do Elasticsearch (ES 8.16+/9.x)
vm.max_map_count                    = 1048576
root@vmi3487682:~# sudo sysctl --system
* Applying /etc/sysctl.d/10-console-messages.conf ...
kernel.printk = 4 4 1 7
* Applying /etc/sysctl.d/10-ipv6-privacy.conf ...
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
* Applying /etc/sysctl.d/10-kernel-hardening.conf ...
kernel.kptr_restrict = 1
* Applying /etc/sysctl.d/10-magic-sysrq.conf ...
kernel.sysrq = 176
* Applying /etc/sysctl.d/10-network-security.conf ...
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
* Applying /etc/sysctl.d/10-panic.conf ...
kernel.panic = 10
* Applying /etc/sysctl.d/10-ptrace.conf ...
kernel.yama.ptrace_scope = 1
* Applying /etc/sysctl.d/10-zeropage.conf ...
vm.mmap_min_addr = 65536
* Applying /usr/lib/sysctl.d/50-default.conf ...
kernel.core_uses_pid = 1
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.default.accept_source_route = 0
sysctl: setting key "net.ipv4.conf.all.accept_source_route": Invalid argument
net.ipv4.conf.default.promote_secondaries = 1
sysctl: setting key "net.ipv4.conf.all.promote_secondaries": Invalid argument
net.ipv4.ping_group_range = 0 2147483647
net.core.default_qdisc = fq_codel
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.protected_regular = 1
fs.protected_fifos = 1
* Applying /usr/lib/sysctl.d/50-pid-max.conf ...
kernel.pid_max = 4194304
* Applying /etc/sysctl.d/99-cloudimg-ipv6.conf ...
net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.use_tempaddr = 0
* Applying /etc/sysctl.d/99-eck.conf ...
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
vm.max_map_count = 1048576
* Applying /usr/lib/sysctl.d/99-protect-links.conf ...
fs.protected_fifos = 1
fs.protected_hardlinks = 1
fs.protected_regular = 2
fs.protected_symlinks = 1
* Applying /etc/sysctl.d/99-sysctl.conf ...
* Applying /etc/sysctl.conf ...
root@vmi3487682:~# sysctl net.ipv4.ip_forward vm.max_map_count
net.ipv4.ip_forward = 1
vm.max_map_count = 1048576
root@vmi3487682:~# sudo apt-get install -y containerd
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  runc
The following NEW packages will be installed:
  containerd runc
0 upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
Need to get 37.8 MB of archives.
After this operation, 140 MB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 runc amd64 1.3.4-0ubuntu1~22.04.1 [9569 kB]
Get:2 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 containerd amd64 2.2.1-0ubuntu1~22.04.2 [28.3 MB]
Fetched 37.8 MB in 30s (1250 kB/s)
Selecting previously unselected package runc.
(Reading database ... 94216 files and directories currently installed.)
Preparing to unpack .../runc_1.3.4-0ubuntu1~22.04.1_amd64.deb ...
Unpacking runc (1.3.4-0ubuntu1~22.04.1) ...
Selecting previously unselected package containerd.
Preparing to unpack .../containerd_2.2.1-0ubuntu1~22.04.2_amd64.deb ...
Unpacking containerd (2.2.1-0ubuntu1~22.04.2) ...
Setting up runc (1.3.4-0ubuntu1~22.04.1) ...
Setting up containerd (2.2.1-0ubuntu1~22.04.2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Restarting services...
 /etc/needrestart/restart.d/systemd-manager
 systemctl restart cron.service irqbalance.service multipathd.service packagekit.service polkit.service serial-getty@ttyS0.service ssh.service systemd-journald.service systemd-networkd.service systemd-resolved.service systemd-timesyncd.service systemd-udevd.service
Service restarts being deferred:
 /etc/needrestart/restart.d/dbus.service
 systemctl restart getty@tty1.service
 systemctl restart networkd-dispatcher.service
 systemctl restart systemd-logind.service
 systemctl restart unattended-upgrades.service
 systemctl restart user@0.service

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
root@vmi3487682:~# sudo mkdir -p /etc/containerd
root@vmi3487682:~# containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
root@vmi3487682:~# sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
root@vmi3487682:~# sudo systemctl restart containerd
root@vmi3487682:~# sudo systemctl enable containerd
root@vmi3487682:~# systemctl is-active containerd
active
root@vmi3487682:~# echo -n "swap:        "; free -h | awk '/Swap/{print ($2=="0B"||$2=="0Bi"||$3=="0B")?"OK":"VERIFICAR ("$2")"}'
echo -n "vm.max_map:  "; [ "$(sysctl -n vm.max_map_count)" = "1048576" ] && echo OK || echo FALHOU
echo -n "ip_forward:  "; [ "$(sysctl -n net.ipv4.ip_forward)" = "1" ] && echo OK || echo FALHOU
echo -n "br_netfilter:"; lsmod | grep -q br_netfilter && echo " OK" || echo " FALHOU"
echo -n "containerd:  "; systemctl is-active --quiet containerd && echo OK || echo FALHOU
swap:        OK
vm.max_map:  OK
ip_forward:  OK
br_netfilter: OK
containerd:  OK