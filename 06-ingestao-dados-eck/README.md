# Módulo 06 — Ingestão de Dados no Kubernetes (com o ECK)

> **Objetivo:** colocar dados **para dentro** do Elasticsearch usando os três coletores do ecossistema — **Beats**, **Logstash** e **Elastic Agent** — todos rodando no Kubernetes e **gerenciados pelo próprio operator ECK** via CRDs.

> **Pré-requisito:** Módulo 02 (`lab-es` + `lab-kb` no ar).

---

## 1. "O Módulo 06 tem operator?" — Sim!

Diferente do que possa parecer, a ingestão **não** precisa de um operator separado. **O mesmo operator ECK** que gerencia `Elasticsearch` e `Kibana` também gerencia os coletores, através de CRDs dedicados:

| Coletor | CRD (`kind`) | `apiVersion` | Como roda tipicamente |
|---|---|---|---|
| **Beats** (Filebeat, Metricbeat…) | `Beat` | `beat.k8s.elastic.co/v1beta1` | **DaemonSet** (um por nó) |
| **Elastic Agent** (+ Fleet Server) | `Agent` | `agent.k8s.elastic.co/v1alpha1` | **DaemonSet** (coleta) / **Deployment** (Fleet Server) |
| **Logstash** | `Logstash` | `logstash.k8s.elastic.co/v1alpha1` | **Deployment** (pipeline central) |

Confirme quais CRDs o seu operator registrou:

```bash
kubectl get crd | grep k8s.elastic.co
# elasticsearches, kibanas, beats, agents, logstashes, apmservers...
```

**A grande vantagem:** ao declarar `elasticsearchRef` (ou `kibanaRef`) no manifesto do coletor, o operator **injeta automaticamente** o endpoint, o usuário, a senha e a **CA de TLS** — você **nunca** cola credenciais ou certificados à mão. É a mesma "mágica" dos módulos anteriores, agora para ingestão.

## 2. Os três coletores — quem é quem

**Beats** são coletores **leves e especializados**: cada um faz uma coisa muito bem. `Filebeat` (logs), `Metricbeat` (métricas), `Packetbeat` (rede), etc. São o jeito clássico e continuam ótimos quando você quer algo enxuto e específico.

**Elastic Agent** é a **evolução** dos Beats: **um único agente** que substitui vários Beats e traz **integrations** (pacotes prontos para Kubernetes, System, Nginx, etc.). Seu grande diferencial é ser **gerenciável centralmente pelo Fleet** (uma UI no Kibana): você instala o agente uma vez e distribui políticas de coleta pela interface, sem reeditar YAML. É a abordagem **recomendada hoje** para observabilidade e segurança.

**Logstash** é diferente dos outros dois: não é um "coletor de ponta", é um **motor de processamento de pipeline**. Ele recebe eventos (de Beats, filas, HTTP…), **transforma** (parse com `grok`, enriquecimento, `mutate`, geoip) e **entrega** a um ou mais destinos. Use quando precisar de **transformações pesadas**, *buffering* ou rotear para vários lugares.

> **Padrão comum:** `Beats/Agent → (Logstash, opcional) → Elasticsearch`. Os coletores de ponta pegam os dados; o Logstash entra no meio só quando há transformação/roteamento a fazer.

## 3. Como cada um roda no Kubernetes

**DaemonSet (Beats e Agent de coleta).** Para coletar **logs e métricas de todos os nós**, você precisa de **um pod em cada nó**. Isso é um DaemonSet — e é por isso que o CRD `Beat`/`Agent` tem a seção `daemonSet`. Cada pod monta, via `hostPath`, os diretórios de log do host (`/var/log/containers`, `/var/log/pods`).

**Deployment (Logstash e Fleet Server).** Um pipeline central (Logstash) ou o Fleet Server não precisam estar em todo nó — rodam como um **Deployment** com uma ou mais réplicas.

**Privilégios.** Ler logs do host e metadados do cluster exige: um **ServiceAccount** com **RBAC** (para o *autodiscover* enriquecer eventos com metadados de pod/namespace), `runAsUser: 0` e, para Filebeat, `hostNetwork: true`. Todos os manifests deste módulo já trazem esse RBAC pronto.

## 4. Standalone vs Fleet (para o Elastic Agent)

O Elastic Agent tem dois modos:

- **Standalone:** a configuração de coleta vive **no próprio manifesto** (`spec.config`). Simples, versionável em Git, sem UI. Bom para começar e para GitOps.
- **Fleet-managed:** o agente se **matricula** em um **Fleet Server**, e as políticas de coleta são gerenciadas pela **UI do Fleet no Kibana**. Escala melhor e é o padrão de produção. No ECK, o Fleet Server é só **outro recurso `Agent`** (com `mode: fleet` e `fleetServerEnabled: true`).

Neste módulo faremos o **standalone** na prática (autocontido) e deixamos o **Fleet** como manifesto de referência comentado.

## 5. O que você faz no laboratório

1. **Filebeat** (CRD `Beat`, DaemonSet) coletando logs dos containers do cluster → ver em **Discover**.
2. **Logstash** (CRD `Logstash`) com um pipeline `beats → filtro → elasticsearch`, recebendo de um Beat.
3. **Elastic Agent standalone** (CRD `Agent`, DaemonSet) coletando logs/métricas do sistema.
4. (Referência) **Fleet Server + Agent Fleet-managed**.

> **Recursos (16 GB):** rode um coletor de cada vez. Filebeat/Agent são leves (~200–400 Mi); o Logstash pede ~1 Gi. Remova o que não estiver usando (`kubectl -n elastic delete beat/agent/logstash <nome>`).

---

➡️ [**Laboratório**](laboratorio.md) · [`manifests/`](manifests/) · [`slides.html`](slides.html)
