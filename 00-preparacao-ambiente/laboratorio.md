# Laboratório 00 — Preparação da VM

> **Pré-requisito:** uma VM Ubuntu Server 22.04/24.04 LTS com 8 vCPU, 16 GB RAM e 100 GB de disco, e acesso `sudo`.
> **Tempo estimado:** 15–20 minutos.

Todos os comandos rodam na **VM (host)**, com o prompt `$`. Você pode executar passo a passo (recomendado para entender) ou usar o script pronto em [`configs/prepare-host.sh`](configs/prepare-host.sh).

---

## Passo 1 — Atualizar o sistema e instalar utilitários

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl gnupg apt-transport-https ca-certificates
```

## Passo 2 — Definir o hostname (opcional, mas recomendado)

```bash
sudo hostnamectl set-hostname eck-lab
```

## Passo 3 — Desligar o swap

```bash
sudo swapoff -a
# torna permanente comentando a entrada de swap no fstab:
sudo sed -i.bak '/\bswap\b/ s/^/#/' /etc/fstab
```

**Validação:**

```bash
free -h        # a linha "Swap" deve mostrar 0B
```

## Passo 4 — Carregar módulos de kernel

```bash
sudo tee /etc/modules-load.d/k8s.conf <<'EOF'
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
```

**Validação:**

```bash
lsmod | grep -E 'overlay|br_netfilter'    # ambos devem aparecer
```

## Passo 5 — Parâmetros de rede + vm.max_map_count (sysctl)

```bash
sudo tee /etc/sysctl.d/99-eck.conf <<'EOF'
# Rede exigida pelo Kubernetes
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
# Exigência do Elasticsearch (ES 8.16+/9.x)
vm.max_map_count                    = 1048576
EOF

sudo sysctl --system      # aplica tudo agora
```

**Validação:**

```bash
sysctl net.ipv4.ip_forward vm.max_map_count
# net.ipv4.ip_forward = 1
# vm.max_map_count = 1048576
```

## Passo 6 — Instalar e configurar o containerd

```bash
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

# Alinhar o containerd ao systemd (cgroups):
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
```

**Validação:**

```bash
systemctl is-active containerd     # deve retornar: active
```

---

## Checklist final do módulo

Rode este bloco — todas as linhas devem "passar":

```bash
echo -n "swap:        "; free -h | awk '/Swap/{print ($2=="0B"||$2=="0Bi"||$3=="0B")?"OK":"VERIFICAR ("$2")"}'
echo -n "vm.max_map:  "; [ "$(sysctl -n vm.max_map_count)" = "1048576" ] && echo OK || echo FALHOU
echo -n "ip_forward:  "; [ "$(sysctl -n net.ipv4.ip_forward)" = "1" ] && echo OK || echo FALHOU
echo -n "br_netfilter:"; lsmod | grep -q br_netfilter && echo " OK" || echo " FALHOU"
echo -n "containerd:  "; systemctl is-active --quiet containerd && echo OK || echo FALHOU
```

Se tudo mostrar **OK**, avance para o **Módulo 01**.

> **Problemas?** Consulte [`../_assets/troubleshooting.md`](../_assets/troubleshooting.md).
