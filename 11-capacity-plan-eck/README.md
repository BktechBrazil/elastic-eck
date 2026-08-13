# Módulo 11 — Capacity Plan do Elasticsearch no ECK

> **Objetivo:** dimensionar um cluster Elasticsearch de forma consciente — memória, CPU, disco e shards — e traduzir esse dimensionamento para o mundo Kubernetes: **requests/limits**, **volumeClaimTemplates** e o **autoscaling** do ECK.

> **Pré-requisito:** Módulos 02 e 04 (nodeSets/shards).

---

## 1. As quatro dimensões do dimensionamento

Planejar capacidade é equilibrar quatro recursos contra o **volume de dados** e o **padrão de carga** (escrita pesada? busca pesada? agregações?):

**Memória (RAM/heap).** O recurso mais crítico do Elasticsearch. Regras de ouro:
- **Heap ≤ 50% da RAM** do nó (o resto vai para o *filesystem cache* do SO, que acelera a busca).
- **Heap ≤ ~30 GB** (acima disso, a JVM perde os *compressed oops* e você paga caro por pouca memória útil).
- Proporção **RAM : disco** por tier: ~1:30 (hot), ~1:160 (warm), maior ainda para cold.

**CPU.** Importa para ingestão, agregações e concorrência de buscas. Menos "regra fixa": você mede e ajusta.

**Disco.** O tamanho dos dados + réplicas + margem. Nunca passe de ~85% (o Elasticsearch tem *watermarks* que bloqueiam alocação quando o disco enche).

**Shards.** Nem grandes demais, nem pequenos demais.

## 2. A matemática dos shards

Shards são a unidade de escala, mas têm custo: cada shard consome memória e recursos de gestão. Duas heurísticas:

- **Tamanho de shard:** mire **10–50 GB por shard**. Muito pequeno = overhead; muito grande = recuperação/realocação lenta.
- **Densidade:** mantenha **abaixo de ~20 shards por GB de heap** por nó. Um nó com 30 GB de heap suporta na ordem de ~600 shards — mas quanto menos, melhor.

Para séries temporais, **não** crie um índice gigante: use **rollover/ILM** (Módulo 08) para gerar shards do tamanho certo ao longo do tempo. Estimativa típica: `nº de shards primários ≈ volume diário / 40 GB`, e ajuste réplicas conforme a necessidade de HA/leitura.

## 3. A tradução para o Kubernetes: requests × limits

No ECK, o dimensionamento vira **`resources`** no `podTemplate`. Aqui há uma sutileza que evita muita dor:

- **Memória:** defina **`requests.memory == limits.memory`**. Se o limite for menor que o uso real, o Kubernetes **mata o pod por OOM**; se request e limit divergirem, o pod fica *Burstable* e sujeito a *eviction* sob pressão. Para o ES (stateful e sensível), **memória garantida** é o certo.
- **Heap:** configure `ES_JAVA_OPTS` (ou deixe o ECK calcular) para **~50% do `requests.memory`**. Ex.: request 8Gi → heap 4g.
- **CPU:** defina **`requests.cpu`** (garantia de agendamento) e seja cauteloso com `limits.cpu` — um limite baixo causa *throttling* que degrada latência. Muitos preferem **request sem limit** de CPU no lab, permitindo bursts.

```yaml
resources:
  requests: { memory: 8Gi, cpu: "2" }
  limits:   { memory: 8Gi }          # == request (memória garantida)
env:
  - { name: ES_JAVA_OPTS, value: -Xms4g -Xmx4g }   # 50% do request
```

## 4. Disco: volumeClaimTemplates

O disco de cada nó é um **PVC** via `volumeClaimTemplates`. Dimensione com folga (dados + réplicas + ~25% de margem) e escolha a `storageClassName` adequada (SSD para hot). **Aumentar** o disco depois é possível se a StorageClass permitir `allowVolumeExpansion` — você edita o `volumeClaimTemplates` e o ECK expande. **Reduzir** não é suportado.

## 5. Escalar: vertical, horizontal e autoscaling

- **Vertical:** dar mais RAM/CPU/disco a cada nó (mudar `resources`/`volumeClaimTemplates`). O operator faz rolling change.
- **Horizontal:** mais nós (aumentar `count` do `nodeSet`). Melhor para distribuir shards e aumentar throughput.
- **Autoscaling do ECK:** o operator pode **ajustar automaticamente** recursos e contagem por *data tier* / papel de ML, com base na necessidade de armazenamento e memória. Define-se um recurso **`ElasticsearchAutoscaler`** com políticas por role (`data_hot`, `data_warm`, `ml`) e limites mín/máx. O operator observa os "deciders" do Elasticsearch e escala dentro dos limites.

> **Licença:** o **autoscaling do Elasticsearch** é um recurso **Enterprise** (use o trial para experimentar). O dimensionamento manual (requests/limits/count) é Basic.

## 6. Monitorar para dimensionar

Dimensionamento não é adivinhação — é medição. Ferramentas:
- `GET _cat/allocation?v` — disco por nó.
- `GET _cat/nodes?v&h=name,heap.percent,ram.percent,cpu,load_1m` — pressão de heap/CPU.
- `GET _cluster/health` e `GET _nodes/stats` — shards, filas, GC.
- `kubectl top nodes` / `kubectl top pods -n elastic` — visão do Kubernetes.
- **Stack Monitoring** no Kibana — histórico de heap, GC, indexação, busca.

## 7. No laboratório

Você vai (a) **medir** o cluster atual (`_cat/allocation`, `_cat/nodes`, `kubectl top`), (b) ajustar **requests/limits e heap** conscientemente e ver o rolling change, (c) **escalar horizontalmente** mudando `count`, e (d) ler um manifesto de **`ElasticsearchAutoscaler`** (referência) entendendo as políticas por tier.

---

➡️ [**Laboratório**](laboratorio.md) · [`manifests/`](manifests/) · [`slides.html`](slides.html)
