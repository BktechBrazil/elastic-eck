# Laboratório 06 — Ingestão com Beats, Logstash e Elastic Agent

> **Pré-requisito:** Módulo 02 (`lab-es` + `lab-kb` no ar).
> **Tempo estimado:** 40–50 minutos.
> **Recursos:** rode **um coletor de cada vez** e remova o anterior antes do próximo (16 GB).

```bash
source ../_assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

Confirme que o operator gerencia a ingestão:

```bash
kubectl get crd | grep -E 'beats|agents|logstashes'
```

---

## Lab A — Filebeat (CRD `Beat`) coletando logs de containers

### Passo 1 — Aplicar o Filebeat (DaemonSet)

```bash
kubectl apply -f manifests/filebeat.yaml
kubectl -n elastic get beat filebeat            # aguarde HEALTH green
kubectl -n elastic get pods -l beat.k8s.elastic.co/name=filebeat
```

> Note que **não colamos senha nem certificado**: o `elasticsearchRef: lab-es` fez o operator injetar tudo.

### Passo 2 — Ver os logs chegando

```bash
curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices/*filebeat*?v" \
  # (com o port-forward do ES ativo do Módulo 03)
```

No **Kibana → Discover**, crie um *data view* `filebeat-*` (ou `.ds-filebeat-*`) e explore os logs dos seus próprios pods do Elastic. 

### Passo 3 — Remover antes de seguir

```bash
kubectl delete -f manifests/filebeat.yaml
```

---

## Lab B — Beats → Logstash → Elasticsearch

### Passo 4 — Subir o Logstash (CRD `Logstash`)

```bash
kubectl apply -f manifests/logstash.yaml
kubectl -n elastic get logstash lab-logstash    # aguarde disponível
kubectl -n elastic get svc | grep lab-logstash  # note o service lab-logstash-ls-beats:5044
```

O pipeline (`input beats → filter mutate → output elasticsearch`) usa as variáveis `LAB_ES_ES_*` que o operator injetou a partir do `elasticsearchRefs`.

### Passo 5 — Apontar um Filebeat para o Logstash

```bash
kubectl apply -f manifests/filebeat-para-logstash.yaml
kubectl -n elastic get beat filebeat-ls
```

### Passo 6 — Validar o índice do Logstash

```bash
curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices/logstash-lab-*?v"
```

No Discover, um *data view* `logstash-lab-*` mostra os eventos com o campo `origem: logstash-lab` que o filtro adicionou. **Prova de que passaram pelo Logstash.**

### Passo 7 — Remover antes de seguir

```bash
kubectl delete -f manifests/filebeat-para-logstash.yaml
kubectl delete -f manifests/logstash.yaml
```

---

## Lab C — Elastic Agent standalone (CRD `Agent`)

### Passo 8 — Subir o Agent (DaemonSet)

```bash
kubectl apply -f manifests/elastic-agent-standalone.yaml
kubectl -n elastic get agent elastic-agent      # aguarde HEALTH green
```

A configuração de coleta (métricas de CPU, memória, rede, filesystem) está **no próprio manifesto** (`spec.config`) — modo standalone, versionável em Git.

### Passo 9 — Ver as métricas do sistema

```bash
curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices/*system*?v"
```

No Kibana, os dados chegam como **data streams** `metrics-system.*`. Explore no Discover ou nos dashboards de System.

### Passo 10 — Remover

```bash
kubectl delete -f manifests/elastic-agent-standalone.yaml
```

---

## Lab D (opcional/avançado) — Elastic Agent gerenciado por Fleet

Leia [`manifests/fleet-referencia.yaml`](manifests/fleet-referencia.yaml). Diferente do standalone, aqui:

1. O **Kibana precisa** das configurações `xpack.fleet.*` (veja o topo do arquivo) — adicione-as ao `lab-kb` e reaplique.
2. Sobe-se um **Fleet Server** (recurso `Agent` com `fleetServerEnabled: true`).
3. Sobe-se o **Agent** com `fleetServerRef` — ele se matricula e recebe políticas pela **UI do Fleet** no Kibana.

```bash
# depois de ajustar o Kibana com xpack.fleet.*:
kubectl apply -f manifests/fleet-referencia.yaml
kubectl -n elastic get agent                      # fleet-server e elastic-agent-fleet
# no Kibana: Management -> Fleet -> Agents (o agente aparece "Healthy")
```

> **Recursos:** o Fleet Server + Agent + as integrations pesam. Em 16 GB, faça este lab com o Filebeat/Logstash já removidos.

---

## ✅ Você aprendeu

- Que a ingestão é gerenciada pelo **mesmo operator ECK**, via CRDs `Beat`, `Logstash` e `Agent`.
- Que `elasticsearchRef`/`kibanaRef` **injetam credenciais e TLS automaticamente**.
- A rodar coletores como **DaemonSet** (Beats/Agent) e o pipeline como **Deployment** (Logstash).
- A diferença entre Elastic Agent **standalone** e **Fleet-managed**, e quando usar cada um.

➡️ **Módulo 07** — visualizar tudo isso: **gráficos, dashboards e gestão de dados no Kibana**.
