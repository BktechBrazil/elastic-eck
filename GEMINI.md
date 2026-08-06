# Memory & Context — Elastic Stack Total (Edição ECK)

Este arquivo serve como **memória de contexto, histórico e guia de arquitetura** para manutenção, evolução e portabilidade do repositório **Elastic Stack Total — Edição ECK (Elastic Cloud on Kubernetes)**.

---

## 1. Visão Geral e Propósito

- **Projeto:** Elastic Stack Total — Edição ECK
- **Objetivo:** Portar o material do curso tradicional/presencial "Elastic Stack Total" (baseado em pacotes/VMs) para uma arquitetura *cloud-native* declarativa executada em Kubernetes com o operator **ECK (Elastic Cloud on Kubernetes)**.
- **Fonte Original:** [Wiki - Domine o Elastic Stack em 15 dias](https://github.com/tornis/elasticstacktotal/wiki)
- **Instrutor / Autor:** Rodrigo Tornis
- **Diretório do Projeto:** `c:\Users\Bktech\Documents\BkTech\ECK Curso\elastic-eck` (anteriormente planejado como `D:\bktech\eck`)

### Histórico de Commits do Repositório
- **Commit `4a1127d` (04/08/2026):** *Treinamento Elastic Stack Total — Edição ECK (Módulos 00–06)*
- **Commit `d0d4337` (06/08/2026):** *Treinamento Elastic Stack Total — Edição ECK (Módulos 07–10)*

---

## 2. Especificações Técnicas e Arquitetura de Referência

### 2.1 Especificações da VM do Laboratório (Single-Node)
- **Recursos:** 8 vCPU | 16 GB RAM | 100 GB Disco
- **Sistema Operacional Host:** Ubuntu Server 22.04 LTS / 24.04 LTS (ou equivalente)
- **Kernel & Ajustes do Host:**
  - `vm.max_map_count = 1048576` (persistente em `/etc/sysctl.d/99-sysctl-eck.conf`)
  - **Swap Desabilitado** (requisito estrito do `kubelet`)

### 2.2 Kubernetes & Provisionamento
- **Distribuição:** Kubernetes Vanilla (puro) via `kubeadm` (topologia *single-node*).
- **Control-Plane:** Taint `node-role.kubernetes.io/control-plane` removido (`kubectl taint nodes --all node-role.kubernetes.io/control-plane-`) para agendar cargas no único nó.
- **CNI:** Flannel / Calico.
- **StorageClass:** `local-path-storage` configurado como default (`storageclass.kubernetes.io/is-default-class: "true"`).
- **Ferramentas de CLI:** `kubectl` e `helm`.

### 2.3 Versões Centralizadas (`_assets/versions.env`)
- **ECK Operator:** `3.4.1`
- **Elastic Stack (ES, Kibana, Agent):** `9.4.2` (Linha Elastic 9.x)
- **Kubernetes:** `1.31`
- **Namespaces Padrão:**
  - `elastic-system`: Operator ECK
  - `elastic`: Clusters Elasticsearch, Kibana, Fleet Server e Agents do curso

### 2.4 Dimensionamento de Recursos (Orçamento de Memória na VM de 16 GB)
- **Elasticsearch Pod:** `requests.memory: 4Gi` | Heap JVM: `2Gi` (`≤ 50%` do container).
- **Kibana Pod:** `requests.memory: 1.5Gi - 2Gi`.
- **SO + K8s (kubelet, etcd, containerd):** ~2 GB.
- **Folga para Ingestão/Demos:** ~6–7 GB RAM | ~3 vCPUs.

---

## 3. Padrão Estrutural dos Módulos

Cada pasta de módulo (`NN-modulo/`) é autocontida e segue rigorosamente a seguinte estrutura de 4 arquivos/diretórios:

```
NN-modulo/
├── README.md        # Teoria, conceitos arquiteturais e justificativas didáticas
├── laboratorio.md   # Passo a passo prático, comandos detalhados e validações esperadas
├── manifests/       # (ou exemplos/) Arquivos YAML de CRDs/recursos K8s ou payloads DSL
└── slides.html      # Apresentação visual interativa baseada em _assets/slide-template.html
```

### Arquivos Compartilhados (`_assets/`)
- `versions.env`: Variáveis de ambiente com versões fixas do projeto.
- `slide-template.html`: Template base em HTML/CSS para criação dos decks de slides.
- `troubleshooting.md`: Guia unificado de resolução de problemas (recuperação de senhas do ECK, TLS, PVCs em Pending, sysctl).

---

## 4. Status e Roadmap dos Módulos

| Módulo | Diretorio | Título / Foco | Status |
|---|---|---|---|
| 00 | `00-preparacao-ambiente/` | Preparação de ambiente (VM, kernel, containerd, swap) | **Concluído** |
| 01 | `01-instalacao-kubernetes/` | Bootstrap K8s (`kubeadm`), StorageClass, Operator ECK (`helm`) | **Concluído** |
| 02 | `02-deploy-elastic-stack-eck/` | Deploy declarativo de ES + Kibana via CRDs | **Concluído** |
| 03 | `03-query-dsl/` | Consultas, filtros e agregações com Query DSL | **Concluído** |
| 04 | `04-nos-shards-segments-eck/` | Arquitetura ES: `nodeSets`, pods, PVCs e storage | **Concluído** |
| 05 | `05-index-settings-mapping/` | Index Settings, Mappings, Analyzers e Aliases | **Concluído** |
| 06 | `06-ingestao-dados-eck/` | Elastic Agent, Fleet Server e Beats em Kubernetes | **Concluído** |
| 07 | `07-kibana-dashboards/` | Kibana: Gráficos, Dashboards e Gestão | **Concluído** |
| 08 | `08-ilm-eck/` | Index Lifecycle Management (ILM), StorageClasses, Hot-Warm | **Concluído** |
| 09 | `09-machine-learning/` | Detecção de Anomalias e ML do Elastic (Atenção à RAM) | **Concluído** |
| 10 | `10-migracao-upgrade-eck/` | Rolling Upgrade declarativo alterando versão no CRD | **Concluído** |
| 11 | `11-capacity-plan-eck/` | Capacity Planning, Requests/Limits e Autoscaling | **Pendente** |
| 12 | `12-genai-eck/` | Elastic GenAI: Playground (RAG) + Agent Builder com LLM local | **Pendente** |

---

## 5. Diretrizes e Regras para Futuras Modificações

Ao modificar ou adicionar conteúdos neste projeto, siga impreterivelmente as regras abaixo:

1. **Centralização de Versões:** NUNCA insira versões *hardcoded* nos arquivos de laboratório sem atualizar ou fazer referência a `_assets/versions.env`.
2. **Convenção de Comandos:**
   - Prompt `$` indica comandos a serem executados na **VM host**.
   - Prompt `#` indica comandos executados **dentro de containers/pods**.
3. **Isolamento de Recursos:** Módulos pesados em memória (**Módulo 09 - ML** e **Módulo 12 - GenAI**) devem orientar o aluno a remover/pausar workloads anteriores para não estourar o limite de 16 GB da VM.
4. **Módulo 12 (Elastic GenAI):**
   - Não utilizar LocalAI.
   - O laboratório deve utilizar o **conector OpenAI-compatível** nativo do Kibana 9.x apontando para um LLM local (Ollama, LM Studio ou vLLM).
   - Foco nos recursos *built-in*: **Playground (RAG)** e **Agent Builder (Agentes GA)**.
5. **Estrutura dos Slides:** Todo novo slide deve herdar a estilização e os componentes visuais de `_assets/slide-template.html`.
6. **Manutenção do `PLANO-PORTABILIDADE-ECK.md`:** Qualquer mudança escopada na portabilidade deve refletir no plano original e nesta memória (`gemini.md`).
