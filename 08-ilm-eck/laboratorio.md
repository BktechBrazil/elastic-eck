# Laboratório 08 — ILM e Data Streams

> **Pré-requisito:** Módulo 02 (`lab-es`). Kibana com **Dev Tools**.
> **Tempo estimado:** 30–40 minutos (parte dele é *esperar* as transições de fase).

Faça tudo no **Kibana → Dev Tools**. Os comandos estão em [`exemplos/ilm-dev-tools.txt`](exemplos/ilm-dev-tools.txt). A política do lab usa tempos **curtos (minutos)** de propósito, para você ver as fases acontecerem.

---

## Parte A — Política e template

### Passo 1 — Criar a política de ILM (comando 1)

Aplique `lab-logs-policy`: rollover na fase **hot** (1 GB ou 5 min), **warm** após 2 min (forcemerge + 0 réplicas), **delete** após 10 min.

### Passo 2 — Index template com data stream (comando 2)

Aplique `lab-logs-template` para `lab-logs-*`, marcando `data_stream: {}` e ligando `index.lifecycle.name` à política.

> É o template que **amarra** padrão de nome + data stream + política + mapping.

## Parte B — Criar e girar o data stream

### Passo 3 — Nascer o data stream (comando 3)

Indexe o primeiro documento em `lab-logs-app`. Como há um template com `data_stream`, o Elastic cria o **data stream** e o primeiro índice de apoio `.ds-lab-logs-app-...-000001`.

### Passo 4 — Ver os bastidores (comando 4)

```text
GET _data_stream/lab-logs-app
```

Você verá o data stream e seus **backing indices**. Você escreve no nome único; o ILM gerencia os índices por baixo.

### Passo 5 — Rollover manual (comando 5)

```text
POST lab-logs-app/_rollover
```

Force a criação do `...-000002`. Confirme com o `GET _data_stream` que agora há dois índices de apoio.

## Parte C — Ver as fases mudarem

### Passo 6 — Explain do ILM (comando 6)

```text
GET lab-logs-app/_ilm/explain
```

Observe o campo `phase` (`hot`) e `action`/`step` de cada índice de apoio.

### Passo 7 — Esperar e reobservar

Indexe mais um documento (comando 7) e **repita o `_ilm/explain` a cada 1–2 minutos**. Você verá o índice mais antigo transitar **hot → warm** (após 2 min) e, mais tarde, ser **deletado** (após 10 min). Essa é a automação do ciclo de vida acontecendo diante dos seus olhos.

## Parte D — A topologia hot-warm (conceitual)

Abra [`manifests/hot-warm-es.yaml`](manifests/hot-warm-es.yaml). Note como os **tiers viram `nodeSets`**: `hot` (papel `data_hot`, SSD) e `warm` (papel `data_warm`, disco barato). Em um cluster assim, a ação `allocate` da fase warm **move fisicamente os shards** para os pods warm.

> **Não aplique** no lab de 16 GB (3 nós pesam). Se quiser testar e tiver como subir 32 GB temporariamente: `kubectl apply -n elastic -f manifests/hot-warm-es.yaml`.

---

## ✅ Você aprendeu

- As **fases** do ciclo de vida (hot/warm/cold/frozen/delete) e suas ações.
- **Rollover** e **data streams**: escrever num nome único enquanto o ILM gira os índices de apoio.
- Como um **index template** amarra padrão + data stream + política + mapping.
- Que a topologia **hot-warm** no ECK é, mais uma vez, **desenhar `nodeSets`** — e a fase warm realoca os shards para o tier certo.

➡️ **Módulo 09** — encontrar padrões e anomalias automaticamente com **Machine Learning**.
