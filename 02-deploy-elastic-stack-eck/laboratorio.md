# Laboratório 02 — Deploy consciente do Elastic Stack

> **Pré-requisito:** Módulo 01 concluído (operator + quickstart).
> **Tempo estimado:** 25–35 minutos.

Comandos com `$` rodam na **VM**. As versões vêm de `_assets/versions.env`:

```bash
source ../_assets/versions.env
echo "ECK=$ECK_VERSION  STACK=$STACK_VERSION  K8S=$K8S_VERSION"
```

> **Nota:** Caso esteja executando os comandos sem ter o repositório clonado na VM, certifique-se de ter executado `source _assets/versions.env` a partir da raiz `/root`.

---

## Parte A — Dissecar o que o operator criou

### Passo 1 — Ver todos os objetos do quickstart

```bash
kubectl -n elastic get elasticsearch,statefulset,pod,pvc,svc,secret | grep -i quickstart
```

Observe: um StatefulSet, um Pod, um PVC, dois Services (`-es-http` e `-es-transport`) e vários Secrets.

### Passo 2 — Ler a configuração efetiva e os eventos

```bash
kubectl -n elastic describe elasticsearch quickstart | sed -n '/Events/,$p'
kubectl -n elastic get elasticsearch quickstart -o yaml | less   # 'q' para sair
```

### Passo 3 — Provar a reconciliação

Apague o pod e veja o operator/StatefulSet recriá-lo:

```bash
kubectl -n elastic delete pod quickstart-es-default-0
kubectl -n elastic get pods -w      # o pod volta sozinho; Ctrl+C quando estiver Running novamente
```

---

## Parte B — Recriar como um cluster configurado (`lab-es`)

O quickstart é mínimo. Agora subimos um cluster nomeado com escolhas explícitas para o single-node (0 réplicas evita o estado `yellow`).

### Passo 4 — Aplicar o cluster do laboratório

> **Nota:** Caso não tenha clonado o repositório na VM, crie os arquivos de manifesto `elasticsearch.yaml` e `kibana.yaml` executando os comandos abaixo (à prova de falhas de cola SSH):

```bash
mkdir -p manifests

echo 'apiVersion: elasticsearch.k8s.elastic.co/v1' > manifests/elasticsearch.yaml
echo 'kind: Elasticsearch' >> manifests/elasticsearch.yaml
echo 'metadata:' >> manifests/elasticsearch.yaml
echo '  name: lab-es' >> manifests/elasticsearch.yaml
echo 'spec:' >> manifests/elasticsearch.yaml
echo '  version: 9.4.2' >> manifests/elasticsearch.yaml
echo '  nodeSets:' >> manifests/elasticsearch.yaml
echo '    - name: default' >> manifests/elasticsearch.yaml
echo '      count: 1' >> manifests/elasticsearch.yaml
echo '      config:' >> manifests/elasticsearch.yaml
echo '        node.store.allow_mmap: true' >> manifests/elasticsearch.yaml
echo '      podTemplate:' >> manifests/elasticsearch.yaml
echo '        spec:' >> manifests/elasticsearch.yaml
echo '          containers:' >> manifests/elasticsearch.yaml
echo '            - name: elasticsearch' >> manifests/elasticsearch.yaml
echo '              env:' >> manifests/elasticsearch.yaml
echo '                - name: ES_JAVA_OPTS' >> manifests/elasticsearch.yaml
echo '                  value: -Xms2g -Xmx2g' >> manifests/elasticsearch.yaml
echo '              resources:' >> manifests/elasticsearch.yaml
echo '                requests:' >> manifests/elasticsearch.yaml
echo '                  memory: 4Gi' >> manifests/elasticsearch.yaml
echo '                  cpu: "1"' >> manifests/elasticsearch.yaml
echo '                limits:' >> manifests/elasticsearch.yaml
echo '                  memory: 4Gi' >> manifests/elasticsearch.yaml
echo '      volumeClaimTemplates:' >> manifests/elasticsearch.yaml
echo '        - metadata:' >> manifests/elasticsearch.yaml
echo '            name: elasticsearch-data' >> manifests/elasticsearch.yaml
echo '          spec:' >> manifests/elasticsearch.yaml
echo '            accessModes: [ReadWriteOnce]' >> manifests/elasticsearch.yaml
echo '            resources:' >> manifests/elasticsearch.yaml
echo '              requests:' >> manifests/elasticsearch.yaml
echo '                storage: 20Gi' >> manifests/elasticsearch.yaml
echo '            storageClassName: local-path' >> manifests/elasticsearch.yaml

echo 'apiVersion: kibana.k8s.elastic.co/v1' > manifests/kibana.yaml
echo 'kind: Kibana' >> manifests/kibana.yaml
echo 'metadata:' >> manifests/kibana.yaml
echo '  name: lab-kb' >> manifests/kibana.yaml
echo 'spec:' >> manifests/kibana.yaml
echo '  version: 9.4.2' >> manifests/kibana.yaml
echo '  count: 1' >> manifests/kibana.yaml
echo '  elasticsearchRef:' >> manifests/kibana.yaml
echo '    name: lab-es' >> manifests/kibana.yaml
echo '  podTemplate:' >> manifests/kibana.yaml
echo '    spec:' >> manifests/kibana.yaml
echo '      containers:' >> manifests/kibana.yaml
echo '        - name: kibana' >> manifests/kibana.yaml
echo '          resources:' >> manifests/kibana.yaml
echo '            requests:' >> manifests/kibana.yaml
echo '              memory: 1Gi' >> manifests/kibana.yaml
echo '              cpu: 500m' >> manifests/kibana.yaml
echo '            limits:' >> manifests/kibana.yaml
echo '              memory: 2Gi' >> manifests/kibana.yaml
```

Aplique os manifestos do cluster do laboratório:

```bash
kubectl apply -n elastic -f manifests/elasticsearch.yaml
kubectl apply -n elastic -f manifests/kibana.yaml
kubectl -n elastic get pods -w    # aguarde até os pods lab-es e lab-kb ficarem Running
```

### Passo 5 — Senha e acesso do `lab-es`

```bash
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user \
  -o go-template='{{.data.elastic | base64decode}}')
echo "Senha: $PASSWORD"

# Encerra túneis anteriores para liberar as portas 9200/5601
pkill -f "port-forward" || true

kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cluster/health?pretty
# status deve ser "green" (0 réplicas em single-node)
```

### Passo 6 — Validar TLS com a CA (sem `-k`)

```bash
kubectl -n elastic get secret lab-es-es-http-certs-public \
  -o go-template='{{index .data "ca.crt" | base64decode}}' > ca.crt
curl --cacert ca.crt -u "elastic:$PASSWORD" https://localhost:9200
```

---

## Parte C — Kibana + dados de amostra

### Passo 7 — Abrir o Kibana

Para VMs remotas de cloud (Contabo), exponha o serviço com `--address 0.0.0.0`:

```bash
pkill -f "port-forward.*5601" || true
kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-http 5601 &
# navegador: https://<IP_DA_VM>:5601  (usuário: elastic / senha: $PASSWORD)
```

### Passo 8 — Carregar os "Sample data"

No Kibana: **☰ Menu → Integrations** (ou a página inicial) **→ "Add sample data"** e adicione **Sample eCommerce orders** e **Sample web logs**. Esses conjuntos serão usados nos Módulos 03, 05 e 07.

**Validação:**

```bash
curl -k -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices?v" | grep kibana_sample
```

---

## ✅ Checklist do módulo

```bash
kubectl -n elastic get elasticsearch lab-es          # HEALTH green
kubectl -n elastic get kibana lab-kb                 # HEALTH green
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cat/indices?v | grep sample
```

Você entende agora o que o operator cria e como configurar um cluster de forma consciente. No **Módulo 03** vamos explorar esses dados com a Query DSL.

> **Nota de recursos:** manter *dois* clusters (quickstart + lab-es) pode pesar em 16 GB. Se quiser, remova o quickstart: `kubectl -n elastic delete elasticsearch quickstart && kubectl -n elastic delete kibana quickstart`.
