# Módulo 04 — Nós, Índices, Shards e Segments (no ECK)

> **Objetivo:** entender a arquitetura interna do Elasticsearch — **papéis de nó**, **shards**, **réplicas** e **segments** — e como cada conceito se traduz nos objetos do **ECK** (`nodeSets`, pods e PVCs). Este é o módulo que conecta "teoria do Elasticsearch" com "realidade do Kubernetes".

> **Pré-requisito:** Módulo 02 (cluster `lab-es` no ar).

---

## 1. Do documento ao disco: a pilha de conceitos

```
Índice            (coleção lógica de documentos: "pedidos")
  └─ Shard        (uma fatia do índice = um índice Lucene completo)
       └─ Segment (arquivos imutáveis dentro do shard; nascem no refresh e são fundidos)
```

**Índice** é a coleção lógica. Ele é **dividido em shards** para caber em vários nós e ser processado em paralelo. Cada **shard é um índice Lucene autônomo** — é a unidade real de armazenamento e busca. Dentro de um shard, os dados vivem em **segments**: arquivos **imutáveis** criados a cada *refresh*. Como são imutáveis, deletar um documento só o marca como apagado; o espaço só é liberado quando o Elastic **funde** (merge) segments. Entender isso explica por que "otimizar" um índice é fazer *force merge*.

## 2. Primary shards × réplicas

- **Primary shard**: onde o documento é escrito primeiro. O número de primários é **definido na criação do índice** e (via de regra) não muda depois.
- **Réplica**: uma **cópia** de um primary em **outro nó**. Serve para (a) **alta disponibilidade** (se um nó cai, a réplica assume) e (b) **throughput de leitura** (buscas podem usar réplicas).

> **Regra de ouro:** uma réplica **nunca** é alocada no mesmo nó do seu primary — senão não protegeria contra a queda daquele nó. Por isso, em **single-node**, réplicas ficam *unassigned* e o cluster fica **yellow**. Nos labs, usamos `number_of_replicas: 0` para índices de teste.

## 3. Papéis de nó (`node.roles`)

Um nó pode acumular papéis; em clusters grandes, separá-los traz estabilidade:

| Papel | Função |
|---|---|
| `master` | Coordena o cluster (estado, alocação de shards). Poucos e dedicados em produção. |
| `data` (`data_hot`, `data_warm`, `data_cold`, `data_frozen`) | Guardam shards. A base do hot-warm (Módulo 08). |
| `ingest` | Executam *ingest pipelines* (pré-processamento). |
| `ml` | Rodam jobs de Machine Learning (Módulo 09). |
| *coordinating* | Sem papel = só roteiam requisições e juntam resultados. |

## 4. A tradução para o ECK

Aqui está a ponte do curso:

| Conceito Elasticsearch | Objeto no ECK |
|---|---|
| Um **nó** | Um **Pod** (gerido por um StatefulSet) |
| Um **grupo de nós com o mesmo papel** | Um **`nodeSet`** (com `config.node.roles`) |
| Escalar o número de nós | Mudar **`count`** no `nodeSet` |
| Disco de um nó | Um **PVC** (via `volumeClaimTemplates`) |
| Topologia hot-warm | **Vários `nodeSets`** com papéis/recursos diferentes |

Ou seja: **arquitetura de cluster no ECK é desenhar a lista de `nodeSets`**. Quer 3 masters dedicados e 6 data nodes? São dois `nodeSets`, `count: 3` e `count: 6`. O operator cuida de identidade, discos e rolling changes.

```yaml
nodeSets:
  - name: masters
    count: 3
    config: { node.roles: ["master"] }
  - name: data
    count: 6
    config: { node.roles: ["data","ingest"] }
```

## 5. As APIs `_cat` que você vai amar

Diagnóstico rápido, legível por humanos:

- `GET _cat/nodes?v` — nós, papéis, heap, CPU.
- `GET _cat/shards/<indice>?v` — onde cada shard (primary/replica) está e seu estado.
- `GET _cat/segments/<indice>?v` — segments por shard (quantos, tamanho, docs deletados).
- `GET _cluster/health?level=shards` — saúde por shard.

## 6. No laboratório

Você vai (a) inspecionar nós e shards do `lab-es`, (b) criar um índice com múltiplos primários e ver a réplica ficar *unassigned* em single-node, (c) subir um cluster **`topo-es`** com **2 data nodes** e ver a réplica ser alocada, (d) observar **segments** e fazer um **force merge**.

> **Recursos:** o `topo-es` (2 nós) somado ao `lab-es` pode não caber em 16 GB. **Pare o `lab-es` antes** (`kubectl -n elastic delete elasticsearch lab-es`) ou use os heaps reduzidos do manifest.

---

➡️ [**Laboratório**](laboratorio.md) · [`manifests/`](manifests/) · [`slides.html`](slides.html)
