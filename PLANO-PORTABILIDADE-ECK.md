# Planejamento de Portabilidade — Curso "Elastic Stack Total" → ECK (Elastic Cloud on Kubernetes)

**Projeto:** Portabilidade de Treinamento Elastic
**Data:** 03/08/2026
**Fonte:** https://github.com/tornis/elasticstacktotal/wiki ("Domine o Elastic Stack em 15 dias")
**Alvo:** Elastic Cloud on Kubernetes — ECK / operator (https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s)
**Pasta do projeto:** `D:\bktech\eck`

---

## 1. Objetivo

Portar o conteúdo técnico do curso presencial/tradicional "Elastic Stack Total" para uma versão executada sobre **Kubernetes usando o operator ECK**. O material portado deve preservar a jornada didática do curso original (introdução → instalação → operação → tópicos avançados), mas substituir toda a camada de *deployment* — hoje baseada em instalação por pacotes/tarball em VMs — pela abordagem declarativa do ECK (CRDs, `kubectl`/Helm, PVCs, rolling upgrades pelo operator).

Cada módulo, na estrutura final, terá: explicações/teoria, laboratórios práticos, arquivos de configuração (YAML/manifests) e **slides em HTML ricos em recursos visuais**, além de um README raiz.

---

## 2. Estrutura do curso original (inventário)

A wiki de origem possui 13 páginas:

| # | Página original | Natureza | Impacto da portabilidade |
|---|---|---|---|
| — | Home – Preparação de ambiente | Infra (VM, SSH) | **Reescrever** — vira preparação da VM + cluster K8s |
| 01 | Introdução ao Elastic Stack | Conceitual | Manter + acrescentar "Elastic no Kubernetes / arquitetura ECK" |
| 02 | Instalação e Configuração do Elastic Stack | Deployment | **Substituir** — deploy de ES+Kibana via ECK (CRDs) |
| 03 | Explorando os Dados: Query DSL | Plano de dados | Manter quase inalterado |
| 04 | Tipos de Nós, Índice, Shards e Segments | Arquitetura ES | Adaptar — `nodeSets`, topologia de pods, PVCs |
| 05 | Index Settings: Mapping, Analyzers, Aliases | Plano de dados | Manter quase inalterado |
| 06 | Ingestão de Dados no Elasticsearch | Ingestão | Adaptar — Elastic Agent/Fleet/Beats/Logstash no K8s |
| 07 | Kibana: Gráficos, Dashboards, Gestão | Plano de dados | Manter quase inalterado |
| 08 | Index Lifecycle Management (ILM) | Operação | Adaptar — storage classes, hot-warm via `nodeSets`/afinidade |
| 09 | Elastic Machine Learning | Feature | Manter conceito; **ressalva de recursos** |
| 10 | Migração – Atualização de versão Kibana | Operação | Adaptar — rolling upgrade mudando a versão no CRD |
| 11 | Capacity Plan do Elasticsearch | Planejamento | Adaptar — requests/limits, autoscaling do ECK |
| 12 | Elastic GenAI (Playground + Agent Builder) | Feature | Reescrever — RAG com LLM **local** (conector OpenAI-compatível) e agentes; **ressalva de recursos** |

> Observação: a Home do curso já exige "8 CPU, 16 GB RAM, 100 GB" — exatamente a VM disponível.

### Nota — reformulação do Módulo 12 (Elastic GenAI)

O Elastic atual já contempla nativamente a customização com **LLMs locais**, então o módulo **deixa de depender do LocalAI**. A capacidade GenAI passa a ser construída sobre dois recursos *built-in* do Kibana:

- **Playground (RAG):** interface para conversar com os dados do Elasticsearch via *retrieval augmented generation* — gera as queries, recupera os documentos e envia ao LLM. Suporta **LLMs locais compatíveis com a API OpenAI** (LM Studio, Ollama, vLLM) por meio do **conector OpenAI**.
- **Agent Builder (agentes):** plataforma GA para criar **agentes de IA** que respondem e agem sobre os dados do Elasticsearch em linguagem natural, com *tools*, *skills*, chat, integração **MCP** e workflows. Nas versões recentes do Elastic (9.x), o Agent Builder é a evolução GA do antigo Playground de RAG.

Em um deployment **self-managed via ECK** não existe "Elastic Managed LLM" (oferta de Cloud/Serverless): o LLM é sempre configurado por **conector**, o que torna o cenário de **LLM local** o caminho natural do lab. O conteúdo do módulo cobre: configurar o conector OpenAI-compatível apontando para um LLM local, montar RAG no Playground sobre um índice do curso e criar um agente no Agent Builder com *tools* de busca. **Ressalva:** rodar um LLM local junto do ES em 16 GB é pesado — usar modelo pequeno e, idealmente, subir o LLM sob demanda (ou bump temporário para 32 GB).

---

## 3. Arquitetura de referência do laboratório

### 3.1 Viabilidade da VM (16 GB RAM / 8 vCPU / 100 GB) — **VIÁVEL**

A VM está no piso recomendado pelo próprio curso. Para um laboratório **single-node** ela atende à maior parte dos módulos, desde que o Elasticsearch seja dimensionado com modéstia (o erro clássico é o ES reivindicar metade da RAM do nó). Orçamento de recursos proposto como padrão do lab:

| Componente | RAM (request) | Heap JVM | vCPU |
|---|---|---|---|
| SO + Kubernetes (control plane + system pods) | ~2 GB | — | ~1 |
| Operator ECK | ~0,3–0,5 GB | — | < 0,5 |
| Elasticsearch (1 nó) | 4 GB | 2 GB | 1–2 |
| Kibana | 1,5–2 GB | — | ~0,5–1 |
| **Folga p/ ingestão / Agent / demos** | **~6–7 GB** | — | ~3 |
| **Total comprometido** | **~8–9 GB** | | **~4–5** |

Sobra folga confortável (~6–7 GB, ~3 vCPU) para os exercícios de ingestão e visualização.

**Regra de ouro do heap:** manter o heap da JVM em ≤ 50% da RAM do container **e** ≤ ~26–30 GB. No lab, `resources.requests.memory: 4Gi` com heap de 2 GB é o ponto de equilíbrio.

**Storage:** os 100 GB acomodam bem as imagens de container, os PVCs do ES (data) e os datasets de exercício. Reservar ~40–50 GB para PVCs.

### 3.2 Distribuição de Kubernetes — cluster single-node

Conforme definido, o lab usa **Kubernetes puro (vanilla)** em topologia **single-node**, provisionado com **kubeadm**. Como o Módulo 1 é justamente "instalar o Kubernetes", esse é o caminho de maior valor didático: o aluno vê o bootstrap real de um cluster (API server, etcd, kubelet, CNI). O control-plane é habilitado a agendar cargas (removendo o taint `node-role.kubernetes.io/control-plane`), já que é o único nó.

Toda a operação do cluster e do Elastic Stack é feita com as duas ferramentas padrão do ecossistema: **`kubectl`** (aplicar manifests, inspecionar objetos, `port-forward`, obter segredos) e **`helm`** (instalar o operator ECK e, quando conveniente, recursos Elastic via charts oficiais da Elastic). Não são usados atalhos de distribuições "tudo-em-um".

Componentes que o Módulo 1 precisa garantir no cluster:
- **Container runtime** (containerd) e **CNI** (Calico ou Flannel).
- **StorageClass default** com provisionamento dinâmico (ex.: `local-path-provisioner` aplicado via `kubectl`) para os PVCs do Elasticsearch.
- **Operator ECK** instalado **via Helm** (chart oficial `eck-operator`) e suas CRDs registradas — com `kubectl` para validação.

### 3.3 Pré-requisitos de sistema/kernel

- `vm.max_map_count = 1048576` (exigência do Elasticsearch **8.16+ / 9.x**; para 8.15 ou anterior, `262144`).
- **Swap desabilitado** (requisito do kubelet).
- Como o lab é **uma VM única**, o `vm.max_map_count` pode ser setado direto no host via `sysctl` (persistente em `/etc/sysctl.d/`), **evitando os initContainers privilegiados** que seriam necessários em clusters gerenciados. Esse é um ótimo ponto didático de simplificação.

### 3.4 Ressalvas de capacidade

- **Módulo 09 (Machine Learning)** e **Módulo 12 (GenAI com LLM local)** são os mais pesados em RAM (jobs de ML + LLM local competem pela mesma memória). Recomendações para caberem em 16 GB: rodá-los **isolados** (subir/derrubar o restante), usar modelos/datasets pequenos e, quando possível, sinalizar no material que um **upgrade temporário para 32 GB** melhora bastante a experiência.
- Demos de **alta disponibilidade / alocação de shards (Módulo 04)** funcionam com um ES de 2–3 nós usando heap pequeno (1 GB cada) — cabem, mas com pouca folga; usar datasets reduzidos.

---

## 4. Estrutura do repositório alvo

```
eck/
├── README.md                        # visão geral, pré-requisitos, índice dos módulos, como usar o lab
├── 00-preparacao-ambiente/          # VM, SO, pré-requisitos de kernel, acesso
├── 01-instalacao-kubernetes/        # (detalhado na seção 7)
├── 02-deploy-elastic-stack-eck/     # ES + Kibana via CRDs (substitui o antigo "Instalação")
├── 03-query-dsl/
├── 04-nos-shards-segments-eck/      # nodeSets, topologia de pods, PVCs
├── 05-index-settings-mapping/
├── 06-ingestao-dados-eck/           # Elastic Agent/Fleet/Beats no K8s
├── 07-kibana-dashboards/
├── 08-ilm-eck/                      # storage classes, hot-warm
├── 09-machine-learning/
├── 10-migracao-upgrade-eck/         # rolling upgrade via CRD
├── 11-capacity-plan-eck/            # requests/limits, autoscaling
├── 12-genai-eck/                    # Playground (RAG) + Agent Builder com LLM local (conector OpenAI-compatível)
└── _assets/                         # template de slides HTML, biblioteca de YAMLs, imagens, troubleshooting
```

Padrão interno de cada pasta de módulo:

```
NN-modulo/
├── README.md            # explicação + teoria do módulo
├── laboratorio.md       # passo a passo do lab (comandos, validações, resultados esperados)
├── manifests/           # arquivos .yaml de configuração usados no lab
└── slides.html          # deck HTML rico em recursos visuais
```

---

## 5. Fases do projeto de portabilidade

**Fase 0 — Extração e inventário.** Copiar e catalogar o conteúdo dos 12 módulos da wiki (texto, comandos, prints), identificando o que é plano de dados (reaproveitável) e o que é deployment (a reescrever).

**Fase 1 — Fundações.** Criar a estrutura do repositório (Seção 4), o README raiz, o template de slides HTML e a biblioteca inicial de manifests (`_assets/`). Definir a versão-alvo do Elastic Stack e do ECK.

**Fase 2 — Arquitetura de referência do lab (validada 1×).** Documentar e **testar na VM** a montagem completa: preparação do SO → cluster single-node → StorageClass → operator ECK → cluster ES+Kibana "quickstart". Esse ambiente vira a base reutilizada por todos os módulos.

**Fase 3 — Módulo 1 (novo, específico de ECK).** Construir teoria, labs, YAMLs e slides da instalação do Kubernetes + ECK (detalhe na Seção 7).

**Fase 4 — Portabilidade iterativa dos Módulos 2–12.** Seguir o mapeamento da Seção 2, um módulo por vez, reaproveitando ao máximo o conteúdo de plano de dados e reescrevendo a camada de deployment.

**Fase 5 — Ativos compartilhados.** Consolidar template de slides, biblioteca de manifests, guia de troubleshooting comum (senhas/segredos do ECK, `kubectl get elasticsearch`, PVCs presos, etc.).

**Fase 6 — Validação.** Executar todos os labs na VM de referência (16 GB/8 vCPU), corrigir dimensionamentos e registrar tempos/consumo reais por módulo.

Sugestão de ordem de esforço: Fase 0 → 1 → 2 → 3 (Módulo 1) e depois priorizar Módulo 02 (deploy) e Módulo 04 (nodeSets/PVCs), que são os de maior mudança conceitual; os módulos de plano de dados (03, 05, 07) são portados rapidamente.

---

## 6. Módulo 1 — Instalação do Kubernetes (detalhamento)

Pasta: `01-instalacao-kubernetes/`

### 6.1 Teoria / explicação (`README.md`)
- O que é Kubernetes e por que o **operator pattern** / CRDs para o Elastic (o operator "sabe" operar o ES: provisionar, escalar, atualizar, gerar certificados/segredos).
- Arquitetura de um cluster: control plane (API server, scheduler, controller-manager, etcd), nós, kubelet, container runtime, CNI.
- Topologia **single-node** do lab e suas implicações (control plane agendando cargas).
- Provisionamento com **kubeadm** (Kubernetes puro): `kubeadm init`, `kubeconfig`, CNI e o taint do control-plane no cenário single-node.
- Ferramentas de operação: **`kubectl`** (manifests, inspeção, `port-forward`, segredos) e **`helm`** (charts oficiais da Elastic).
- Storage no Kubernetes: StorageClass, PV, PVC e o papel do provisioner dinâmico para o Elasticsearch.
- Pré-requisitos de kernel/sistema: `vm.max_map_count`, swap off, módulos de rede.
- Visão geral do ECK: CRDs (`Elasticsearch`, `Kibana`, `Agent`, `Beat`…), namespace do operator, gestão de segredos/certificados TLS.

### 6.2 Laboratórios (`laboratorio.md`)
- **Lab 1.1 — Preparar a VM:** Ubuntu Server, aplicar `sysctl vm.max_map_count=1048576` (persistente), desabilitar swap, instalar containerd e utilitários.
- **Lab 1.2 — Subir o cluster single-node:** instalar kubeadm/kubelet/kubectl e o `helm`, executar `kubeadm init`, configurar o `kubeconfig`, instalar o CNI, **remover o taint do control-plane** para permitir agendamento; validar com `kubectl get nodes` / `kubectl get pods -A`.
- **Lab 1.3 — StorageClass default:** instalar/validar o provisioner `local-path` e marcá-lo como default.
- **Lab 1.4 — Instalar o operator ECK com Helm:** adicionar o repositório Helm da Elastic e instalar o chart `eck-operator`; validar o pod do operator (`kubectl -n elastic-system get pods`) e as CRDs (`kubectl get crd | grep elastic`). Mostrar também, como referência, a instalação equivalente por manifest YAML com `kubectl apply`.
- **Lab 1.5 — Validar a plataforma (quickstart):** deploy de um `Elasticsearch` mínimo + `Kibana`, obter a senha do usuário `elastic` (segredo gerado pelo operator), `curl` no endpoint com TLS e acesso ao Kibana via port-forward.

### 6.3 Arquivos de configuração (`manifests/`)
- `99-sysctl-eck.conf` (kernel).
- `install-k8s.md` (comandos de bootstrap com kubeadm + instalação do `helm`).
- `local-path-storage.yaml` (StorageClass, aplicado com `kubectl apply`).
- `eck-operator-values.yaml` (values do chart Helm `eck-operator`).
- `elasticsearch-quickstart.yaml` (1 nó, requests/heap dimensionados p/ o lab).
- `kibana-quickstart.yaml`.

### 6.4 Slides (`slides.html`)
Deck HTML rico visualmente cobrindo a jornada: motivação (por que ECK) → arquitetura de cluster → bootstrap single-node → StorageClass → operator ECK → primeiro cluster ES+Kibana. Com diagramas de arquitetura, blocos de comando destacados e checklist de validação.

---

## 7. Padrões e ativos compartilhados
- **Template de slides HTML** único (paleta, tipografia, componentes de diagrama) reutilizado por todos os módulos.
- **Biblioteca de manifests** versionada (`_assets/manifests/`) com blocos reaproveitáveis (ES nodeSet padrão do lab, Kibana, Agent).
- **Guia de troubleshooting** transversal: recuperar senha do `elastic`, TLS/certificados do ECK, PVCs `Pending`, pods sem recursos, `vm.max_map_count`.
- **Convenção de versões:** fixar a versão do Elastic Stack e do ECK usadas em todo o curso, para reprodutibilidade dos labs.

---

## 8. Riscos e mitigação

| Risco | Mitigação |
|---|---|
| ES estourar a RAM da VM | Dimensionamento padrão do lab (heap 2 GB / request 4 GB) e datasets reduzidos |
| Módulos 09 (ML) e 12 (GenAI) não caberem em 16 GB | Rodar isolados; modelos pequenos; sinalizar upgrade opcional p/ 32 GB |
| `vm.max_map_count` não aplicado → ES não sobe | Setar no host (VM única) e checklist no Lab 1.1 |
| PVC preso em `Pending` | StorageClass default validada no Lab 1.3 |
| Deriva de versão entre módulos | Versão fixada nos ativos compartilhados |

---

## 9. Próximos passos sugeridos
1. Aprovar este planejamento e a arquitetura de referência do lab.
2. Fixar as versões-alvo (Elastic Stack e ECK).
3. Autorizar a Fase 1 (scaffold do repositório + README + template de slides) e, na sequência, a construção do **Módulo 1**.

---

*Documento de planejamento — sujeito a ajuste conforme validação prática na VM de laboratório.*
