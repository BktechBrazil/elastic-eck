# Elastic Stack Total — Edição ECK (Elastic Cloud on Kubernetes)

Curso técnico do **Elastic Stack** executado sobre **Kubernetes** com o operator **ECK** (Elastic Cloud on Kubernetes). É a portabilidade do curso "Domine o Elastic Stack em 15 dias" para uma abordagem *cloud-native*: em vez de instalar Elasticsearch e Kibana por pacotes em uma VM, todo o ciclo de vida (provisionar, escalar, atualizar, certificar) é declarado em YAML e gerido pelo operator.

> **Fonte original:** https://github.com/tornis/elasticstacktotal/wiki
> **Documentação do ECK:** https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s

---

## Para quem é este curso

Profissionais de infraestrutura, SRE/DevOps, dados e observabilidade que querem operar o Elastic Stack em Kubernetes. Não é preciso ser especialista em Kubernetes — o **Módulo 01** ensina a instalar o cluster do zero.

## O que você vai construir

Um ambiente completo do Elastic Stack rodando em um cluster Kubernetes **single-node** montado em uma única VM, e vai operá-lo de ponta a ponta: ingestão, consulta, dashboards, ciclo de vida de índices, machine learning, upgrades e GenAI.

---

## Ambiente de laboratório (leia antes de começar)

| Item | Especificação do lab |
|---|---|
| VM | 8 vCPU · 16 GB RAM · 100 GB de disco |
| Sistema operacional | Ubuntu Server 22.04/24.04 LTS (ou equivalente) |
| Kubernetes | **puro (vanilla), single-node, via `kubeadm`** |
| Ferramentas | `kubectl` e `helm` |
| Operator | **ECK 3.4.1** |
| Elastic Stack | **9.x** (fixado em `9.4.2` neste material) |

As versões acima ficam centralizadas em [`_assets/versions.env`](_assets/versions.env). Para atualizar o curso a uma nova release, altere esse arquivo e os manifests que o referenciam.

> **Dimensionamento:** o Elasticsearch é configurado com heap modesto (2 GB) e `requests.memory: 4Gi`. Isso deixa folga na VM para Kibana, ingestão e demais exercícios. Os módulos **09 (Machine Learning)** e **12 (GenAI)** são os mais pesados; rode-os isoladamente e, se possível, com um upgrade temporário para 32 GB.

---

## Estrutura do repositório

Cada módulo é autocontido e segue o mesmo padrão:

```
NN-modulo/
├── README.md        # teoria e explicações didáticas
├── laboratorio.md   # passo a passo prático (comandos + validações)
├── manifests/       # arquivos .yaml usados no laboratório
└── slides.html      # apresentação visual do módulo (abra no navegador)
```

## Trilha dos módulos

| Módulo | Título | O que você aprende |
|---|---|---|
| [00](00-preparacao-ambiente/) | Preparação de ambiente | Preparar a VM, kernel (`vm.max_map_count`), swap, pré-requisitos |
| [01](01-instalacao-kubernetes/) | Instalação do Kubernetes + ECK | Subir um cluster com `kubeadm`, StorageClass, instalar o operator ECK |
| [02](02-deploy-elastic-stack-eck/) | Deploy do Elastic Stack no ECK | Criar Elasticsearch + Kibana via CRDs, TLS, segredos, acesso |
| [03](03-query-dsl/) | Explorando dados: Query DSL | Buscar e filtrar dados com a Query DSL |
| [04](04-nos-shards-segments-eck/) | Nós, Shards e Segments | Arquitetura do ES mapeada em `nodeSets`, pods e PVCs |
| [05](05-index-settings-mapping/) | Index Settings | Mapping, analyzers e aliases |
| [06](06-ingestao-dados-eck/) | Ingestão de Dados | Elastic Agent, Fleet e Beats no Kubernetes |
| [07](07-kibana-dashboards/) | Kibana: Dashboards | Gráficos, dashboards e gestão de dados |
| [08](08-ilm-eck/) | Index Lifecycle Management | ILM, storage classes e arquitetura hot-warm |
| [09](09-machine-learning/) | Machine Learning | Detecção de anomalias e ML do Elastic |
| [10](10-migracao-upgrade-eck/) | Migração / Upgrade | Rolling upgrade mudando a versão no CRD |
| [11](11-capacity-plan-eck/) | Capacity Plan | Dimensionamento, requests/limits e autoscaling |
| [12](12-genai-eck/) | Elastic GenAI | Playground (RAG) + Agent Builder com LLM local |

## Como usar

1. Faça os módulos **00 → 12 em ordem** na primeira vez — cada um assume o ambiente do anterior.
2. Em cada módulo: leia o `README.md`, faça o `laboratorio.md` na VM e use os `slides.html` para revisão ou para ministrar a aula.
3. Consulte [`_assets/troubleshooting.md`](_assets/troubleshooting.md) sempre que algo falhar.

---

## Convenções

- Comandos executados na **VM/host** aparecem com o prompt `$`.
- Comandos executados **dentro de um pod** aparecem com `#` ou indicados no texto.
- Namespaces do curso: `elastic-system` (operator) e `elastic` (nossos clusters ES/Kibana).

## Licença e créditos

Material didático derivado do curso "Elastic Stack Total" e adaptado para ECK. Elasticsearch, Kibana, Elastic Agent e ECK são marcas da Elastic N.V.
