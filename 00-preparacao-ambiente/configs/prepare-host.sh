#!/usr/bin/env bash
# prepare-host.sh — Preparação da VM para Kubernetes + Elastic Stack (ECK)
# Uso: sudo bash prepare-host.sh
# Idempotente: pode ser executado mais de uma vez com segurança.
set -euo pipefail

echo "==> [1/6] Atualizando sistema e utilitários"
apt-get update && apt-get upgrade -y
apt-get install -y curl gnupg apt-transport-https ca-certificates

echo "==> [2/6] Desligando swap (permanente)"
swapoff -a
sed -i.bak '/\bswap\b/ s/^\([^#]\)/#\1/' /etc/fstab

echo "==> [3/6] Carregando módulos de kernel"
tee /etc/modules-load.d/k8s.conf >/dev/null <<'EOF'
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

echo "==> [4/6] Aplicando parâmetros sysctl (rede + vm.max_map_count)"
tee /etc/sysctl.d/99-eck.conf >/dev/null <<'EOF'
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
vm.max_map_count                    = 1048576
EOF
sysctl --system >/dev/null

echo "==> [5/6] Instalando e configurando containerd"
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

echo "==> [6/6] Validação"
fail=0
[ "$(sysctl -n vm.max_map_count)" = "1048576" ] && echo "  vm.max_map_count OK" || { echo "  vm.max_map_count FALHOU"; fail=1; }
[ "$(sysctl -n net.ipv4.ip_forward)" = "1" ]    && echo "  ip_forward OK"       || { echo "  ip_forward FALHOU"; fail=1; }
lsmod | grep -q br_netfilter                     && echo "  br_netfilter OK"     || { echo "  br_netfilter FALHOU"; fail=1; }
systemctl is-active --quiet containerd           && echo "  containerd OK"       || { echo "  containerd FALHOU"; fail=1; }

[ "$fail" = "0" ] && echo "==> Host pronto! Prossiga para o Módulo 01." || { echo "==> Há falhas — revise acima."; exit 1; }
