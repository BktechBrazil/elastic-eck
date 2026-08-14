# Laboratório 11 — Dimensionamento e Autoscaling

> **Pré-requisito:** Módulo 02 (`lab-es`). metrics-server ativo (Módulo 01).
> **Tempo estimado:** 25–35 minutos.

```bash
source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
```

---

## Parte A — Medir antes de dimensionar

### Passo 1 — Disco e shards por nó

```bash
es "/_cat/allocation?v"
es "/_cat/nodes?v&h=name,heap.percent,ram.percent,cpu,load_1m,disk.used_percent"
```

Observe `heap.percent` (pressão de memória) e `disk.used_percent` (cuidado com os watermarks ~85%).

### Passo 2 — Visão do Kubernetes

```bash
kubectl top nodes
kubectl top pods -n elastic
```

Compare o consumo real com os `requests`/`limits` definidos.

### Passo 3 — Contagem de shards

```bash
es "/_cat/shards?v" | wc -l
es "/_cluster/health?pretty" | grep -E 'active_shards|number_of_nodes'
```

## Parte B — Dimensionamento vertical consciente

### Passo 4 — Aplicar recursos dimensionados
Caso não possua o manifests/lab-es-sized.yaml, execute o comando abaixo:

```bash
mkdir -p manifests
cat << 'EOF' > manifests/lab-es-sized.yaml
# Exemplo de dimensionamento consciente (Módulo 11).
# request == limit de memória (garantida); heap = 50% do request; CPU com request e sem limit.
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: lab-es
spec:
  version: 9.4.4
  nodeSets:
    - name: default
      count: 1                     # escale horizontalmente mudando este valor
      config:
        node.store.allow_mmap: true
      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              env:
                - name: ES_JAVA_OPTS
                  value: -Xms3g -Xmx3g       # 50% do requests.memory (6Gi)
              resources:
                requests:
                  memory: 6Gi
                  cpu: "2"
                limits:
                  memory: 6Gi              # == request: memória garantida (evita OOM/eviction)
                  # sem limits.cpu: permite bursts sem throttling
      volumeClaimTemplates:
        - metadata: { name: elasticsearch-data }
          spec:
            accessModes: [ReadWriteOnce]
            resources: { requests: { storage: 30Gi } }
            storageClassName: local-path   # precisa de allowVolumeExpansion p/ crescer depois
EOF
```

Aplique o exemplo com memória garantida e heap em 50% (6Gi / heap 3g):

```bash
kubectl apply -n elastic -f manifests/lab-es-sized.yaml
kubectl -n elastic get pods -w        # o operator faz rolling change; Ctrl+C ao estabilizar
```

Confirme o heap efetivo:

```bash
es "/_nodes/jvm?filter_path=**.mem.heap_max_in_bytes"
```

> **Regra:** `requests.memory == limits.memory` (memória garantida) e `heap = 50%` do request.

## Parte C — Escalar horizontalmente

### Passo 5 — Aumentar o número de nós

Edite `manifests/lab-es-sized.yaml` mudando `count: 1` para `count: 2` (se a VM comportar; reduza a memória para 4Gi/heap 2g se necessário) e aplique:

```bash
kubectl apply -n elastic -f manifests/lab-es-sized.yaml
es "/_cat/nodes?v&h=name,node.role"      # dois nós
```

Veja os shards se redistribuírem:

```bash
es "/_cat/allocation?v"
```

> Em single-node com pouca RAM, pule esta parte ou reduza os requests. O conceito é: **mais nós = mais throughput e distribuição de shards**.

## Parte D — Autoscaling (referência)

### Passo 6 — Ler a política de autoscaling

Abra [`manifests/elasticsearch-autoscaler.yaml`](manifests/elasticsearch-autoscaler.yaml). Note as **policies por role** (`data_hot`, `data_warm`, `ml`) com limites `min/max` de nodeCount, cpu, memory e storage. O operator escala **dentro** desses limites, observando os *deciders* do Elasticsearch.

> **Licença:** autoscaling é **Enterprise** (trial). Para testar, ative o trial (Módulo 09), tenha nodeSets por tier e aplique o `ElasticsearchAutoscaler`. **Não** aplique no lab de 16 GB sem folga.

---

## ✅ Você aprendeu

- As **quatro dimensões** (memória, CPU, disco, shards) e as **regras de ouro** (heap ≤ 50% e ≤ 30 GB; shard de 10–50 GB; < ~20 shards/GB de heap; disco < 85%).
- A traduzir isso em **requests/limits** (memória garantida) e **heap = 50% do request**.
- A escalar **vertical** (recursos) e **horizontalmente** (`count`).
- Que o **ECK tem autoscaling** por tier via `ElasticsearchAutoscaler` (Enterprise).

➡️ **Módulo 12** — o grand finale: **Elastic GenAI** com Playground (RAG) e Agent Builder usando LLM local.
