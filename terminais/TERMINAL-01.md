root@vmi3487682:~# source ../_assets/versions.env   # define ECK_VERSION, STACK_VERSION, K8S_VERSION...
echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
-bash: ../_assets/versions.env: No such file or directory
ECK=  STACK=  K8S=
root@vmi3487682:~# mkdir -p _assets
> cat <<'EOF' > _assets/versions.env
> export ECK_VERSION="3.4.1"
> export STACK_VERSION="9.4.2"
> export K8S_VERSION="1.31"
> export ECK_NAMESPACE="elastic-system"
> export LAB_NAMESPACE="elastic"
> EOF
> source _assets/versions.env
> echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
>
> ^C
root@vmi3487682:~# mkdir -p _assets
root@vmi3487682:~# cat <<'EOF' > _assets/versions.env
> export ECK_VERSION="3.4.1"
> export STACK_VERSION="9.4.2"
> export K8S_VERSION="1.31"
> export ECK_NAMESPACE="elastic-system"
> export LAB_NAMESPACE="elastic"
> EOF
> source _assets/versions.env
> echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
>
> ^C
root@vmi3487682:~# cat <<'EOF' > _assets/versions.env
> export ECK_VERSION="3.4.1"
> export STACK_VERSION="9.4.2"
> export K8S_VERSION="1.31"
> export ECK_NAMESPACE="elastic-system"
> export LAB_NAMESPACE="elastic"
> EOF
> ^C
root@vmi3487682:~# ls -la _assets/
total 8
drwxr-xr-x 2 root root 4096 Aug  7 14:31 .
drwx------ 6 root root 4096 Aug  7 14:31 ..
root@vmi3487682:~# mkdir -p _assets
echo 'export ECK_VERSION="3.4.1"' > _assets/versions.env
echo 'export STACK_VERSION="9.4.2"' >> _assets/versions.env
echo 'export K8S_VERSION="1.31"' >> _assets/versions.env
echo 'export ECK_NAMESPACE="elastic-system"' >> _assets/versions.env
echo 'export LAB_NAMESPACE="elastic"' >> _assets/versions.env

source _assets/versions.env
echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
ECK=3.4.1  STACK=9.4.2  K8S=1.31
root@vmi3487682:~# ls -la _assets/
total 12
drwxr-xr-x 2 root root 4096 Aug  7 14:35 .
drwx------ 6 root root 4096 Aug  7 14:31 ..
-rw-r--r-- 1 root root  151 Aug  7 14:35 versions.env
root@vmi3487682:~# source ../_assets/versions.env   # define ECK_VERSION, STACK_VERSION, K8S_VERSION...
echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
-bash: ../_assets/versions.env: No such file or directory
ECK=3.4.1  STACK=9.4.2  K8S=1.31
root@vmi3487682:~# pwd
/root
root@vmi3487682:~# ls -la
total 36
drwx------  6 root root 4096 Aug  7 14:31 .
drwxr-xr-x 19 root root 4096 Aug  6 22:10 ..
-rw-------  1 root root  123 Aug  7 13:51 .bash_history
-rw-r--r--  1 root root 3106 Oct 15  2021 .bashrc
drwx------  2 root root 4096 Aug  7 13:37 .cache
-rw-r--r--  1 root root  161 Jul  9  2019 .profile
drwx------  2 root root 4096 Aug  6 22:10 .ssh
drwxr-xr-x  2 root root 4096 Aug  7 14:35 _assets
drwx------  3 root root 4096 Aug  6 22:10 snap
root@vmi3487682:~# ls -la _assets/
total 12
drwxr-xr-x 2 root root 4096 Aug  7 14:35 .
drwx------ 6 root root 4096 Aug  7 14:31 ..
-rw-r--r-- 1 root root  151 Aug  7 14:35 versions.env
root@vmi3487682:~# sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /
Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease
Hit:3 http://archive.ubuntu.com/ubuntu jammy InRelease
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease [1192 B]
Get:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]
Get:5 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  Packages [20.8 kB]
Hit:6 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:7 http://archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [3714 kB]
Get:8 http://archive.ubuntu.com/ubuntu jammy-updates/universe amd64 Packages [1279 kB]
Fetched 5143 kB in 2s (2653 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  cri-tools kubernetes-cni
The following NEW packages will be installed:
  cri-tools kubeadm kubectl kubelet kubernetes-cni
0 upgraded, 5 newly installed, 0 to remove and 0 not upgraded.
Need to get 88.1 MB of archives.
After this operation, 317 MB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  cri-tools 1.31.1-1.1 [15.7 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubeadm 1.31.14-1.1 [11.6 MB]
Get:3 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubectl 1.31.14-1.1 [11.5 MB]
Get:4 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubernetes-cni 1.5.1-1.1 [33.9 MB]
Get:5 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubelet 1.31.14-1.1 [15.4 MB]
Fetched 88.1 MB in 1s (60.5 MB/s)
Selecting previously unselected package cri-tools.
(Reading database ... 94280 files and directories currently installed.)
Preparing to unpack .../cri-tools_1.31.1-1.1_amd64.deb ...
Unpacking cri-tools (1.31.1-1.1) ...
Selecting previously unselected package kubeadm.
Preparing to unpack .../kubeadm_1.31.14-1.1_amd64.deb ...
Unpacking kubeadm (1.31.14-1.1) ...
Selecting previously unselected package kubectl.
Preparing to unpack .../kubectl_1.31.14-1.1_amd64.deb ...
Unpacking kubectl (1.31.14-1.1) ...
Selecting previously unselected package kubernetes-cni.
Preparing to unpack .../kubernetes-cni_1.5.1-1.1_amd64.deb ...
Unpacking kubernetes-cni (1.5.1-1.1) ...
Selecting previously unselected package kubelet.
Preparing to unpack .../kubelet_1.31.14-1.1_amd64.deb ...
Unpacking kubelet (1.31.14-1.1) ...
Setting up kubectl (1.31.14-1.1) ...
Setting up cri-tools (1.31.1-1.1) ...
Setting up kubernetes-cni (1.5.1-1.1) ...
Setting up kubeadm (1.31.14-1.1) ...
Setting up kubelet (1.31.14-1.1) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Restarting services...
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
kubelet set on hold.
kubeadm set on hold.
kubectl set on hold.
root@vmi3487682:~# sudo kubeadm init --pod-network-cidr=192.168.0.0/16
I0807 14:39:26.691241   20452 version.go:261] remote version is much newer: v1.36.3; falling back to: stable-1.31
[init] Using Kubernetes version: v1.31.14
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR FileExisting-conntrack]: conntrack not found in system path
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
root@vmi3487682:~# sudo apt-get install -y conntrack socat
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  conntrack socat
0 upgraded, 2 newly installed, 0 to remove and 0 not upgraded.
Need to get 383 kB of archives.
After this operation, 1486 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu jammy/main amd64 conntrack amd64 1:1.4.6-2build2 [33.5 kB]
Get:2 http://archive.ubuntu.com/ubuntu jammy/main amd64 socat amd64 1.7.4.1-3ubuntu4 [349 kB]
Fetched 383 kB in 1s (751 kB/s)
Selecting previously unselected package conntrack.
(Reading database ... 94334 files and directories currently installed.)
Preparing to unpack .../conntrack_1%3a1.4.6-2build2_amd64.deb ...
Unpacking conntrack (1:1.4.6-2build2) ...
Selecting previously unselected package socat.
Preparing to unpack .../socat_1.7.4.1-3ubuntu4_amd64.deb ...
Unpacking socat (1.7.4.1-3ubuntu4) ...
Setting up conntrack (1:1.4.6-2build2) ...
Setting up socat (1.7.4.1-3ubuntu4) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...
Scanning candidates...
Scanning linux images...


Restarting services...
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
root@vmi3487682:~# sudo kubeadm init --pod-network-cidr=192.168.0.0/16
I0807 14:42:26.493701   20687 version.go:261] remote version is much newer: v1.36.3; falling back to: stable-1.31
[init] Using Kubernetes version: v1.31.14
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action beforehand using 'kubeadm config images pull'
W0807 14:42:26.611911   20687 checks.go:843] detected that the sandbox image "" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [eck-lab kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 207.244.255.225]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [eck-lab localhost] and IPs [207.244.255.225 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [eck-lab localhost] and IPs [207.244.255.225 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "super-admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests"
[kubelet-check] Waiting for a healthy kubelet at http://127.0.0.1:10248/healthz. This can take up to 4m0s
[kubelet-check] The kubelet is healthy after 1.501471693s
[api-check] Waiting for a healthy API server. This can take up to 4m0s
[api-check] The API server is healthy after 6.004098436s
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node eck-lab as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node eck-lab as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: vy29om.l9v47a46q7exwxzj
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 207.244.255.225:6443 --token vy29om.l9v47a46q7exwxzj \
        --discovery-token-ca-cert-hash sha256:cbf51a9423b2870f6116430d25472e14395277b77a64832a6a480a8eecdd4555
root@vmi3487682:~# mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
root@vmi3487682:~# kubectl get nodes
NAME      STATUS     ROLES           AGE     VERSION
eck-lab   NotReady   control-plane   3m40s   v1.31.14
root@vmi3487682:~# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
namespace/tigera-operator created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgpfilters.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/tiers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/adminnetworkpolicies.policy.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/apiservers.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/imagesets.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/installations.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/tigerastatuses.operator.tigera.io created
serviceaccount/tigera-operator created
clusterrole.rbac.authorization.k8s.io/tigera-operator created
clusterrolebinding.rbac.authorization.k8s.io/tigera-operator created
deployment.apps/tigera-operator created
root@vmi3487682:~# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml
installation.operator.tigera.io/default created
apiserver.operator.tigera.io/default created
root@vmi3487682:~# kubectl get nodes -w
NAME      STATUS     ROLES           AGE     VERSION
eck-lab   NotReady   control-plane   4m18s   v1.31.14
eck-lab   NotReady   control-plane   4m26s   v1.31.14
eck-lab   NotReady   control-plane   4m26s   v1.31.14
eck-lab   NotReady   control-plane   4m26s   v1.31.14
eck-lab   Ready      control-plane   4m28s   v1.31.14
eck-lab   Ready      control-plane   4m28s   v1.31.14
^Croot@vmi3487682:~kubectl taint nodes --all node-role.kubernetes.io/control-plane-e-
node/eck-lab untainted
root@vmi3487682:~# kubectl get nodes
NAME      STATUS   ROLES           AGE     VERSION
eck-lab   Ready    control-plane   4m48s   v1.31.14
root@vmi3487682:~# kubectl get pods -A | grep -v Running
NAMESPACE          NAME                                       READY   STATUS    RESTARTS   AGE
root@vmi3487682:~# kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.30/deploy/local-path-storage.yaml
kubectl patch storageclass local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

kubectl get storageclass
namespace/local-path-storage created
serviceaccount/local-path-provisioner-service-account created
role.rbac.authorization.k8s.io/local-path-provisioner-role created
clusterrole.rbac.authorization.k8s.io/local-path-provisioner-role created
rolebinding.rbac.authorization.k8s.io/local-path-provisioner-bind created
clusterrolebinding.rbac.authorization.k8s.io/local-path-provisioner-bind created
deployment.apps/local-path-provisioner created
storageclass.storage.k8s.io/local-path created
configmap/local-path-config created
storageclass.storage.k8s.io/local-path patched
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  1s
root@vmi3487682:~# kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
serviceaccount/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
service/metrics-server created
deployment.apps/metrics-server created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
root@vmi3487682:~# kubectl -n kube-system patch deployment metrics-server --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
deployment.apps/metrics-server patched
root@vmi3487682:~# curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
Downloading https://get.helm.sh/helm-v3.21.3-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
version.BuildInfo{Version:"v3.21.3", GitCommit:"1ad6e68924fdf6fb0c7dcef8e9e1dfc0f36eaed6", GitTreeState:"clean", GoVersion:"go1.26.5"}
root@vmi3487682:~# helm repo add elastic https://helm.elastic.co
helm repo update
helm install elastic-operator elastic/eck-operator \
  -n ${ECK_NAMESPACE} --create-namespace --version ${ECK_VERSION}
"elastic" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "elastic" chart repository
Update Complete. ⎈Happy Helming!⎈
NAME: elastic-operator
LAST DEPLOYED: Fri Aug  7 14:48:57 2026
NAMESPACE: elastic-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Inspect the operator logs by running the following command:
   kubectl logs -n elastic-system sts/elastic-operator
root@vmi3487682:~# kubectl -n ${ECK_NAMESPACE} get pods           # elastic-operator-0  Running
kubectl get crd | grep k8s.elastic.co          # elasticsearches, kibanas, agents, beats...
kubectl -n ${ECK_NAMESPACE} logs statefulset/elastic-operator | tail -5
NAME                 READY   STATUS    RESTARTS   AGE
elastic-operator-0   1/1     Running   0          18s
agents.agent.k8s.elastic.co                            2026-08-07T12:48:58Z
apmservers.apm.k8s.elastic.co                          2026-08-07T12:48:58Z
autoopsagentpolicies.autoops.k8s.elastic.co            2026-08-07T12:48:58Z
beats.beat.k8s.elastic.co                              2026-08-07T12:48:58Z
elasticmapsservers.maps.k8s.elastic.co                 2026-08-07T12:48:58Z
elasticsearchautoscalers.autoscaling.k8s.elastic.co    2026-08-07T12:48:58Z
elasticsearches.elasticsearch.k8s.elastic.co           2026-08-07T12:48:58Z
enterprisesearches.enterprisesearch.k8s.elastic.co     2026-08-07T12:48:58Z
kibanas.kibana.k8s.elastic.co                          2026-08-07T12:48:58Z
logstashes.logstash.k8s.elastic.co                     2026-08-07T12:48:58Z
packageregistries.packageregistry.k8s.elastic.co       2026-08-07T12:48:58Z
stackconfigpolicies.stackconfigpolicy.k8s.elastic.co   2026-08-07T12:48:58Z
{"log.level":"info","@timestamp":"2026-08-07T12:49:14.571Z","log.logger":"resource-reporter","message":"Creating resource","service.version":"3.4.1+2f8ab6aa","service.type":"eck","ecs.version":"1.4.0","kind":"ConfigMap","namespace":"elastic-system","name":"elastic-licensing"}
{"log.level":"info","@timestamp":"2026-08-07T12:49:14.578Z","log.logger":"resource-reporter","message":"Created resource successfully","service.version":"3.4.1+2f8ab6aa","service.type":"eck","ecs.version":"1.4.0","kind":"ConfigMap","namespace":"elastic-system","name":"elastic-licensing","resourceVersion":"1569"}
{"log.level":"info","@timestamp":"2026-08-07T12:49:14.584Z","log.logger":"manager","message":"Orphan secrets garbage collection complete","service.version":"3.4.1+2f8ab6aa","service.type":"eck","ecs.version":"1.4.0"}
{"log.level":"info","@timestamp":"2026-08-07T12:49:14.584Z","log.logger":"garbage-collection","message":"Starting AutoOps garbage collection","service.version":"3.4.1+2f8ab6aa","service.type":"eck","ecs.version":"1.4.0"}
{"log.level":"info","@timestamp":"2026-08-07T12:49:14.584Z","log.logger":"garbage-collection","message":"AutoOps garbage collection complete","service.version":"3.4.1+2f8ab6aa","service.type":"eck","ecs.version":"1.4.0"}
root@vmi3487682:~# kubectl create -f https://download.elastic.co/downloads/eck/${ECK_VERSION}/crds.yaml
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "agents.agent.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "apmservers.apm.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "autoopsagentpolicies.autoops.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "beats.beat.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "elasticmapsservers.maps.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "elasticsearchautoscalers.autoscaling.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "elasticsearches.elasticsearch.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "enterprisesearches.enterprisesearch.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "kibanas.kibana.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "logstashes.logstash.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "packageregistries.packageregistry.k8s.elastic.co" already exists
Error from server (AlreadyExists): error when creating "https://download.elastic.co/downloads/eck/3.4.1/crds.yaml": customresourcedefinitions.apiextensions.k8s.io "stackconfigpolicies.stackconfigpolicy.k8s.elastic.co" already exists
root@vmi3487682:~# kubectl apply -f https://download.elastic.co/downloads/eck/${ECK_VERSION}/operator.yaml
Warning: resource namespaces/elastic-system is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
namespace/elastic-system configured
Warning: resource serviceaccounts/elastic-operator is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
serviceaccount/elastic-operator configured
secret/elastic-webhook-server-cert created
Warning: resource configmaps/elastic-operator is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
configmap/elastic-operator configured
Warning: resource clusterroles/elastic-operator is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
clusterrole.rbac.authorization.k8s.io/elastic-operator configured
Warning: resource clusterroles/elastic-operator-view is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
clusterrole.rbac.authorization.k8s.io/elastic-operator-view configured
Warning: resource clusterroles/elastic-operator-edit is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
clusterrole.rbac.authorization.k8s.io/elastic-operator-edit configured
Warning: resource clusterrolebindings/elastic-operator is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
clusterrolebinding.rbac.authorization.k8s.io/elastic-operator configured
service/elastic-webhook-server created
Warning: resource statefulsets/elastic-operator is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
validatingwebhookconfiguration.admissionregistration.k8s.io/elastic-webhook.k8s.elastic.co created
The StatefulSet "elastic-operator" is invalid: spec: Forbidden: updates to statefulset spec for fields other than 'replicas', 'ordinals', 'template', 'updateStrategy', 'persistentVolumeClaimRetentionPolicy' and 'minReadySeconds' are forbidden
root@vmi3487682:~# kubectl create namespace ${LAB_NAMESPACE}
kubectl apply -n ${LAB_NAMESPACE} -f manifests/elasticsearch-quickstart.yaml
kubectl apply -n ${LAB_NAMESPACE} -f manifests/kibana-quickstart.yaml
namespace/elastic created
error: the path "manifests/elasticsearch-quickstart.yaml" does not exist
error: the path "manifests/kibana-quickstart.yaml" does not exist
root@vmi3487682:~# mkdir -p manifests

cat <<'EOF' > manifests/elasticsearch-quickstart.yaml
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: quickstart
spec:
  version: 9.4.2
  nodeSets:
    - name: default
      count: 1
      config:
        node.store.allow_mmap: true
      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              env:
                - name: ES_JAVA_OPTS
                  value: -Xms2g -Xmx2g
              resources:
                requests:
                  memory: 4Gi
                  cpu: "1"
                limits:
                  memory: 4Gi
      volumeClaimTemplates:
        - metadata:
            name: elasticsearch-data
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 20Gi
            storageClassName: local-path
EOF

cat <<'EOF' > manifests/kibana-quickstart.yaml
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: quickstart
spec:
  version: 9.4.2
EOF           memory: 2Gi
root@vmi3487682:~# kubectl apply -n ${LAB_NAMESPACE} -f manifests/elasticsearch-quickstart.yaml
kubectl apply -n ${LAB_NAMESPACE} -f manifests/kibana-quickstart.yaml
elasticsearch.elasticsearch.k8s.elastic.co/quickstart created
kibana.kibana.k8s.elastic.co/quickstart created
root@vmi3487682:~# kubectl -n ${LAB_NAMESPACE} get elasticsearch,kibana -w
error: you may only specify a single resource type
root@vmi3487682:~# kubectl -n ${LAB_NAMESPACE} get elasticsearch -w
NAME         HEALTH    NODES   VERSION   PHASE             AGE
quickstart   unknown           9.4.2     ApplyingChanges   51s
^Croot@vmi3487682:~kubectl -n ${LAB_NAMESPACE} get kibana -w-w
NAME         HEALTH   NODES   VERSION   AGE
quickstart   red              9.4.2     60s
^Croot@vmi3487682:~echo 'apiVersion: kibana.k8s.elastic.co/v1' > manifests/kibana-quickstart.yamlml
echo 'kind: Kibana' >> manifests/kibana-quickstart.yaml
echo 'metadata:' >> manifests/kibana-quickstart.yaml
echo '  name: quickstart' >> manifests/kibana-quickstart.yaml
echo 'spec:' >> manifests/kibana-quickstart.yaml
echo '  version: 9.4.2' >> manifests/kibana-quickstart.yaml
echo '  count: 1' >> manifests/kibana-quickstart.yaml
echo '  elasticsearchRef:' >> manifests/kibana-quickstart.yaml
echo '    name: quickstart' >> manifests/kibana-quickstart.yaml
echo '  podTemplate:' >> manifests/kibana-quickstart.yaml
echo '    spec:' >> manifests/kibana-quickstart.yaml
echo '      containers:' >> manifests/kibana-quickstart.yaml
echo '        - name: kibana' >> manifests/kibana-quickstart.yaml
echo '          resources:' >> manifests/kibana-quickstart.yaml
echo '            requests:' >> manifests/kibana-quickstart.yaml
echo '              memory: 1Gi' >> manifests/kibana-quickstart.yaml
echo '              cpu: 500m' >> manifests/kibana-quickstart.yaml
echo '            limits:' >> manifests/kibana-quickstart.yaml
echo '              memory: 2Gi' >> manifests/kibana-quickstart.yaml
root@vmi3487682:~# kubectl apply -n ${LAB_NAMESPACE} -f manifests/kibana-quickstart.yaml
kibana.kibana.k8s.elastic.co/quickstart unchanged
root@vmi3487682:~# kubectl -n ${LAB_NAMESPACE} get kibana -w
NAME         HEALTH   NODES   VERSION   AGE
quickstart   green    1       9.4.2     5m43s
^Croot@vmi3487682:~kubectl -n ${LAB_NAMESPACE} get elasticsearch -w-w
NAME         HEALTH   NODES   VERSION   PHASE   AGE
quickstart   green    1       9.4.2     Ready   5m51s
^Croot@vmi3487682:~PASSWORD=$(kubectl -n ${LAB_NAMESPACE} get secret quickstart-es-elastic-user \ \
  -o go-template='{{.data.elastic | base64decode}}')
echo "Senha do elastic: $PASSWORD"
Senha do elastic: mg7IhZIwEg0JOMpoQcQKgD30
root@vmi3487682:~# kubectl -n ${LAB_NAMESPACE} port-forward service/quickstart-es-http 9200 &
curl -k -u "elastic:$PASSWORD" https://localhost:9200      # responde com nome/versão do cluster
[1] 29893
curl: (7) Failed to connect to localhost port 9200 after 0 ms: Connection refused
root@vmi3487682:~# Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
^C
root@vmi3487682:~# curl -k -u "elastic:$PASSWORD" https://localhost:9200
Handling connection for 9200
{
  "name" : "quickstart-es-default-0",
  "cluster_name" : "quickstart",
  "cluster_uuid" : "kAqrrySmTKaSRB-ECoDQGw",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# kubectl -n ${LAB_NAMESPACE} port-forward service/quickstart-kb-http 5601
Forwarding from 127.0.0.1:5601 -> 5601
Forwarding from [::1]:5601 -> 5601
^Croot@vmi3487682:~# kubectl -n ${LAB_NAMESPACE} port-forward service/quickstart-kb-http 5601
Forwarding from 127.0.0.1:5601 -> 5601
Forwarding from [::1]:5601 -> 5601
^Croot@vmi3487682:~kubectl -n ${LAB_NAMESPACE} port-forward --address 0.0.0.0 service/quickstart-kb-http 5601 & &
[2] 33399
root@vmi3487682:~# Forwarding from 0.0.0.0:5601 -> 5601
Handling connection for 5601
Handling connection for 5601
^C
root@vmi3487682:~# kubectl get nodes                                   # Ready
kubectl -n elastic-system get pods                  # operator Running
kubectl get crd | grep -c k8s.elastic.co            # > 0
kubectl -n elastic get elasticsearch,kibana         # HEALTH green/yellow
NAME      STATUS   ROLES           AGE   VERSION
eck-lab   Ready    control-plane   26m   v1.31.14
NAME                 READY   STATUS    RESTARTS      AGE
elastic-operator-0   1/1     Running   1 (19m ago)   20m
12
NAME                                                    HEALTH   NODES   VERSION   PHASE   AGE
elasticsearch.elasticsearch.k8s.elastic.co/quickstart   green    1       9.4.2     Ready   18m

NAME                                      HEALTH   NODES   VERSION   AGE
kibana.kibana.k8s.elastic.co/quickstart   green    1       9.4.2     18m
root@vmi3487682:~# Handling connection for 5601