# Laboratório 04 — Nós, Shards e Segments no ECK

> **Pré-requisito:** Módulo 02 (`lab-es`).
> **Tempo estimado:** 30–40 minutos.

```bash
source ../_assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
```

> As chamadas `_cat` ficam ainda melhores no **Kibana → Dev Tools**. Use o que preferir.

---

## Parte A — Inspecionar o cluster atual (`lab-es`)

### Passo 1 — Nós e papéis

```bash
es "/_cat/nodes?v&h=name,node.role,heap.percent,cpu,disk.used_percent"
```

Em `node.role`, cada letra é um papel (`m`=master, `d`=data, `i`=ingest...). No single-node, um nó acumula todos.

### Passo 2 — Ver os shards existentes

```bash
es "/_cat/shards/kibana_sample_data_ecommerce?v"
```

Coluna `prirep`: `p` = primary, `r` = replica. Coluna `state`: `STARTED` ou `UNASSIGNED`.

## Parte B — Primários, réplicas e o "yellow"

### Passo 3 — Criar um índice com 3 primários e 1 réplica

```bash
es -X PUT "/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'
es "/_cat/shards/loja?v"
```

**Observe:** os 3 primários ficam `STARTED`, mas as 3 réplicas ficam **`UNASSIGNED`** — não há um segundo nó para alocá-las. O cluster fica **yellow**:

```bash
es "/_cluster/health/loja?pretty"
```

### Passo 4 — Corrigir em single-node (réplicas = 0)

```bash
es -X PUT "/loja/_settings" -H 'Content-Type: application/json' -d '{ "index": { "number_of_replicas": 0 } }'
es "/_cluster/health/loja?pretty"      # agora "green"
```

> Lição: `number_of_replicas` é **dinâmico** (muda a quente); `number_of_shards` **não** (definido na criação).

## Parte C — Ver a réplica ser alocada (2 nós)

### Passo 5 — Trocar para o cluster de topologia

```bash
# Pare o lab-es para liberar RAM, depois suba o topo-es (2 nós):
kubectl -n elastic delete elasticsearch lab-es
kubectl apply -n elastic -f manifests/topo-es.yaml
kubectl -n elastic get elasticsearch topo-es -w      # aguarde green; Ctrl+C
```

### Passo 6 — Reconfigurar o acesso e recriar o índice com réplica

```bash
PASSWORD=$(kubectl -n elastic get secret topo-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
kubectl -n elastic port-forward service/topo-es-es-http 9201:9200 &
alias es2="curl -sk -u elastic:$PASSWORD https://localhost:9201"

es2 -X PUT "/loja2?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 2, "number_of_replicas": 1 }
}'
es2 "/_cat/shards/loja2?v"
```

**Observe:** agora **primários e réplicas ficam `STARTED`**, cada réplica em um nó diferente do seu primary. O cluster está **green** com redundância real:

```bash
es2 "/_cat/nodes?v&h=name,node.role"      # dois nós
es2 "/_cluster/health/loja2?pretty"
```

## Parte D — Segments e force merge

### Passo 7 — Indexar alguns documentos e ver segments

```bash
for i in 1 2 3 4 5; do
  es2 -X POST "/loja2/_doc?refresh=true" -H 'Content-Type: application/json' -d "{\"n\": $i}" >/dev/null
done
es2 "/_cat/segments/loja2?v&h=shard,prirep,segment,docs.count,docs.deleted,size"
```

Cada `refresh` tende a criar um novo segment. Muitos segments pequenos = busca menos eficiente.

### Passo 8 — Force merge (otimização)

```bash
es2 -X POST "/loja2/_forcemerge?max_num_segments=1&pretty"
es2 "/_cat/segments/loja2?v&h=shard,prirep,segment,docs.count,docs.deleted"
```

**Observe:** o número de segments cai (idealmente 1 por shard) e `docs.deleted` é recuperado.

> **Cuidado:** *force merge* é caro em I/O — em produção, faça só em índices que **não recebem mais escrita** (ex.: índices antigos, fase warm/cold do ILM — Módulo 08).

---

## ✅ Você aprendeu

- A pilha **índice → shard → segment** e por que segments são imutáveis.
- **Primary vs réplica**, a regra de não colocar réplica no mesmo nó, e o porquê do **yellow** em single-node.
- A tradução **nó = pod**, **grupo de nós = `nodeSet`**, **escala = `count`** no ECK.
- A usar `_cat/nodes|shards|segments` e o **force merge**.

> **Voltar ao ambiente base:** `kubectl -n elastic delete elasticsearch topo-es && kubectl apply -n elastic -f ../02-deploy-elastic-stack-eck/manifests/elasticsearch.yaml`

➡️ **Módulo 05** — como o Elastic interpreta cada campo: **mapping, analyzers e aliases**.
