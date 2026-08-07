# Laboratório 01 — Kubernetes com kubeadm + Operator ECK

> **Pré-requisito:** Módulo 00 concluído (swap off, sysctl, containerd).
> **Tempo estimado:** 30–45 minutos.

Comandos com `$` rodam na **VM**. As versões do curso são centralizadas em `_assets/versions.env`.

Se você clonou o repositório na VM, carregue-as navegando até a pasta do módulo:

```bash
source ../_assets/versions.env   # define ECK_VERSION, STACK_VERSION, K8S_VERSION...
echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
```

> **Nota:** Caso esteja executando os comandos diretamente sem o repositório clonado na VM, você pode criar o arquivo abrindo com o editor (`nano _assets/versions.env`) ou executando os comandos de `echo` abaixo (à prova de falhas de cola via SSH):
>
> ```bash
> mkdir -p _assets
> echo 'export ECK_VERSION="3.4.1"' > _assets/versions.env
> echo 'export STACK_VERSION="9.4.2"' >> _assets/versions.env
> echo 'export K8S_VERSION="1.31"' >> _assets/versions.env
> echo 'export ECK_NAMESPACE="elastic-system"' >> _assets/versions.env
> echo 'export LAB_NAMESPACE="elastic"' >> _assets/versions.env
> 
> source _assets/versions.env
> echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
> ```

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

> **Dica:** Se o preflight check do `kubeadm init` indicar erro de `conntrack not found` (comum em imagens minimalistas de cloud), instale a dependência com 

```bash
sudo apt-get install -y conntrack socat`
```
E execute o comando novamente.

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
```

> **Nota:** Caso esteja executando os comandos sem ter clonado o repositório na VM, crie a pasta `manifests/` e os arquivos YAML executando os comandos abaixo:
>
> ```bash
> mkdir -p manifests
> 
> cat <<'EOF' > manifests/elasticsearch-quickstart.yaml
> apiVersion: elasticsearch.k8s.elastic.co/v1
> kind: Elasticsearch
> metadata:
>   name: quickstart
> spec:
>   version: 9.4.2
>   nodeSets:
>     - name: default
>       count: 1
>       config:
>         node.store.allow_mmap: true
>       podTemplate:
>         spec:
>           containers:
>             - name: elasticsearch
>               env:
>                 - name: ES_JAVA_OPTS
>                   value: -Xms2g -Xmx2g
>               resources:
>                 requests:
>                   memory: 4Gi
>                   cpu: "1"
>                 limits:
>                   memory: 4Gi
>       volumeClaimTemplates:
>         - metadata:
>             name: elasticsearch-data
>           spec:
>             accessModes:
>               - ReadWriteOnce
>             resources:
>               requests:
>                 storage: 20Gi
>             storageClassName: local-path
> EOF
> 
> cat <<'EOF' > manifests/kibana-quickstart.yaml
> apiVersion: kibana.k8s.elastic.co/v1
> kind: Kibana
> metadata:
>   name: quickstart
> spec:
>   version: 9.4.2
>   count: 1
>   elasticsearchRef:
>     name: quickstart
>   podTemplate:
>     spec:
>       containers:
>         - name: kibana
>           resources:
>             requests:
>               memory: 1Gi
>               cpu: 500m
>             limits:
>               memory: 2Gi
> EOF
> ```

Aplique os manifests:

```bash
kubectl apply -n ${LAB_NAMESPACE} -f manifests/elasticsearch-quickstart.yaml
kubectl apply -n ${LAB_NAMESPACE} -f manifests/kibana-quickstart.yaml
```

Acompanhe até ficar `Ready`/`green`:

```bash
kubectl -n ${LAB_NAMESPACE} get elasticsearch -w
kubectl -n ${LAB_NAMESPACE} get kibana -w
# ES: HEALTH green (ou yellow em single-node) · Kibana: HEALTH green
```

### Passo 11 — Pegar a senha do usuário `elastic`

```bash
PASSWORD=$(kubectl -n ${LAB_NAMESPACE} get secret quickstart-es-elastic-user \
  -o go-template='{{.data.elastic | base64decode}}')
echo "Senha do elastic: $PASSWORD"
```

### Passo 12 — Acessar o Elasticsearch e o Kibana

Em um terminal na VM, exponha o Elasticsearch e valide a API:

```bash
kubectl -n ${LAB_NAMESPACE} port-forward service/quickstart-es-http 9200 &
sleep 2
curl -k -u "elastic:$PASSWORD" https://localhost:9200      # responde com nome/versão do cluster
```

Para acessar o Kibana pelo seu navegador local a partir de uma **VM remota (Contabo / Cloud)**, exponha o serviço escutando em todas as interfaces (`--address 0.0.0.0`):

```bash
kubectl -n ${LAB_NAMESPACE} port-forward --address 0.0.0.0 service/quickstart-kb-http 5601 &
```

> **Acesso no Navegador:**
> - **VM Remota / Cloud:** Abra `https://<IP_DA_SUA_VM>:5601` (aceite o aviso de certificado autoassinado HTTPS).
> - **VM Local (VirtualBox / KVM):** Abra `https://localhost:5601`.
> - **Credenciais de Login:** Usuário `elastic` · Senha: `$PASSWORD` (obtida no Passo 11).

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
