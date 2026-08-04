# Laboratório 01 — Kubernetes com kubeadm + Operator ECK

> **Pré-requisito:** Módulo 00 concluído (swap off, sysctl, containerd).
> **Tempo estimado:** 30–45 minutos.

Comandos com `$` rodam na **VM**. As versões vêm de [`../_assets/versions.env`](../_assets/versions.env) — carregue-as:

```bash
source ../_assets/versions.env   # define ECK_VERSION, STACK_VERSION, K8S_VERSION...
echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
```

---

## Parte A — Instalar Kubernetes (kubeadm)

### Passo 1 — Repositório e binários do Kubernetes

```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION}/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl     # trava a versão (upgrade é manual e controlado)
```

### Passo 2 — Inicializar o control plane

O `--pod-network-cidr` precisa combinar com o CNI (Calico usa `192.168.0.0/16` por padrão):

```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

Ao terminar, o `kubeadm` imprime instruções. Guarde-as, mas siga as do próximo passo.

### Passo 3 — Configurar o `kubectl` (kubeconfig)

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes     # verá o nó como "NotReady" (falta a rede — próximo passo)
```

### Passo 4 — Instalar o CNI (Calico)

```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml
```

Aguarde a rede subir (1–2 min) e o nó ficar `Ready`:

```bash
kubectl get nodes -w      # Ctrl+C quando aparecer "Ready"
```

### Passo 5 — Permitir cargas no nó de control plane

Como só temos um nó, removemos o *taint* que bloqueia pods comuns:

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

**Validação da Parte A:**

```bash
kubectl get nodes                       # STATUS = Ready
kubectl get pods -A | grep -v Running   # idealmente nada além de cabeçalho/Completed
```

---

## Parte B — Armazenamento, métricas e Helm

### Passo 6 — StorageClass dinâmica (local-path) como default

O Elasticsearch precisa de PVCs providos automaticamente:

```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.30/deploy/local-path-storage.yaml
kubectl patch storageclass local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

kubectl get storageclass    # local-path deve aparecer como (default)
```

### Passo 7 — metrics-server (para `kubectl top`)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# Em lab single-node com certificado de kubelet autoassinado, habilite TLS inseguro:
kubectl -n kube-system patch deployment metrics-server --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```

### Passo 8 — Instalar o Helm

```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

## Parte C — Instalar o Operator ECK

### Passo 9 — Chart Helm oficial `eck-operator`

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
helm install elastic-operator elastic/eck-operator \
  -n ${ECK_NAMESPACE} --create-namespace --version ${ECK_VERSION}
```

**Validação:**

```bash
kubectl -n ${ECK_NAMESPACE} get pods           # elastic-operator-0  Running
kubectl get crd | grep k8s.elastic.co          # elasticsearches, kibanas, agents, beats...
kubectl -n ${ECK_NAMESPACE} logs statefulset/elastic-operator | tail -5
```

> **Alternativa por manifest (referência):** sem Helm, o mesmo resultado sai de
> `kubectl create -f https://download.elastic.co/downloads/eck/${ECK_VERSION}/crds.yaml` seguido de
> `kubectl apply -f https://download.elastic.co/downloads/eck/${ECK_VERSION}/operator.yaml`.

---

## Parte D — Validar a plataforma (quickstart)

### Passo 10 — Criar o namespace e subir ES + Kibana

```bash
kubectl create namespace ${LAB_NAMESPACE}
kubectl apply -n ${LAB_NAMESPACE} -f manifests/elasticsearch-quickstart.yaml
kubectl apply -n ${LAB_NAMESPACE} -f manifests/kibana-quickstart.yaml
```

Acompanhe até ficar `Ready`/`green`:

```bash
kubectl -n ${LAB_NAMESPACE} get elasticsearch,kibana -w
# ES: HEALTH green (ou yellow em single-node) · Kibana: HEALTH green
```

### Passo 11 — Pegar a senha do usuário `elastic`

```bash
PASSWORD=$(kubectl -n ${LAB_NAMESPACE} get secret quickstart-es-elastic-user \
  -o go-template='{{.data.elastic | base64decode}}')
echo "Senha do elastic: $PASSWORD"
```

### Passo 12 — Acessar o Elasticsearch e o Kibana

Em um terminal, exponha o ES e teste:

```bash
kubectl -n ${LAB_NAMESPACE} port-forward service/quickstart-es-http 9200 &
curl -k -u "elastic:$PASSWORD" https://localhost:9200      # responde com nome/versão do cluster
```

Em outro terminal, exponha o Kibana e abra no navegador:

```bash
kubectl -n ${LAB_NAMESPACE} port-forward service/quickstart-kb-http 5601
# abra https://localhost:5601  (usuário: elastic / senha: $PASSWORD)
```

---

## ✅ Checklist final do módulo

```bash
kubectl get nodes                                   # Ready
kubectl -n elastic-system get pods                  # operator Running
kubectl get crd | grep -c k8s.elastic.co            # > 0
kubectl -n elastic get elasticsearch,kibana         # HEALTH green/yellow
```

Se o Kibana abriu e você logou com o usuário `elastic`, **a plataforma está pronta**. Este ambiente será reaproveitado no **Módulo 02**, onde entenderemos a fundo o que esse quickstart criou.

> **Limpeza (se quiser recomeçar):** `kubectl delete -n elastic -f manifests/` remove ES e Kibana sem tocar no cluster.
> **Problemas?** Veja [`../_assets/troubleshooting.md`](../_assets/troubleshooting.md).
