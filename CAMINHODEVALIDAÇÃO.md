# Caminho de Validação dos Laboratórios - Elastic Stack Total (Edição ECK)

**Início da Auditoria:** 07/08/2026 08:45  
**Ambiente:** VM Contabo (Ubuntu Server / K8s Single-Node)

---

## Log de Execução e Validação

| Timestamp | Módulo | Comando Executado | Resultado / Observação | Status |
| :--- | :--- | :--- | :--- | :--- |
| 07/08/2026 08:45 | - | Inicialização da auditoria | Arquivo de acompanhamento criado | 🟢 Pronto |
| 07/08/2026 08:49 | Módulo 00 | `sudo apt-get update && sudo apt-get upgrade -y` | Sistema atualizado com sucesso (0 upgraded) | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `sudo apt-get install -y curl gnupg apt-transport-https ca-certificates` | Utilitários já na versão mais recente | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `sudo hostnamectl set-hostname eck-lab` | Hostname alterado para eck-lab | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `sudo swapoff -a && sed -i.bak '/\bswap\b/ s/^/#/' /etc/fstab` | Swap desabilitado e fstab atualizado | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `free -h` | Validação de swap: 0B total / 0B used | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `modprobe overlay && modprobe br_netfilter` | Módulos de kernel carregados e persisitidos em `/etc/modules-load.d/k8s.conf` | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `lsmod | grep -E 'overlay|br_netfilter'` | Módulos confirmados em memória (`overlay`, `br_netfilter`) | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `tee /etc/sysctl.d/99-eck.conf` + `sysctl --system` | Ajustes de kernel aplicados (`vm.max_map_count=1048576`, `ip_forward=1`, `bridge-nf`) | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `sysctl net.ipv4.ip_forward vm.max_map_count` | Validação das variáveis de kernel (`1` e `1048576`) | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `sudo apt-get install -y containerd` | Instalação do containerd (v2.2.1) e runc (v1.3.4) | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `containerd config default` + `SystemdCgroup = true` | Configuração do cgroupv2 (SystemdCgroup) e reinício do serviço | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | `systemctl is-active containerd` | Serviço containerd ativo (`active`) | 🟢 OK |
| 07/08/2026 09:04 | Módulo 00 | Script de validação final | Todos os checks retornado OK (`swap`, `vm.max_map`, `ip_forward`, `br_netfilter`, `containerd`) | 🟢 OK |
| 07/08/2026 09:25 | Módulo 01 | `source ../_assets/versions.env` | Erro `-bash: ../_assets/versions.env: No such file or directory` (executado em `/root`). Adicionado fallback de criação rápida do arquivo no `laboratorio.md`. | 🟢 Corrigido |
| 07/08/2026 09:34 | Módulo 01 | Criação de `_assets/versions.env` | Heredoc `cat <<'EOF'` travou no buffer de cola SSH (`> ^C`). Atualizado `laboratorio.md` com `echo` linha a linha e `nano`. | 🟢 Corrigido |
| 07/08/2026 09:37 | Módulo 01 | `source _assets/versions.env` | Variáveis carregadas com sucesso: `ECK=3.4.1 STACK=9.4.2 K8S=1.31` | 🟢 OK |
| 07/08/2026 09:40 | Módulo 01 | `kubeadm init` | Erro `[ERROR FileExisting-conntrack]: conntrack not found`. Adicionado `conntrack` e `socat` ao `00-preparacao-ambiente` e nota no `01-instalacao-kubernetes`. | 🟢 Corrigido |
| 07/08/2026 09:50 | Módulo 01 | `kubectl apply -f manifests/...` | Erro `path "manifests/..." does not exist`. Adicionado bloco de criação automática da pasta `manifests/` e dos arquivos YAML no `laboratorio.md`. | 🟢 Corrigido |
| 07/08/2026 09:54 | Módulo 01 | `kubectl get elasticsearch,kibana -w` | Erro `you may only specify a single resource type`. Ajustado `laboratorio.md` para `kubectl get pods -w`. Corrigido truncamento SSH do manifesto do Kibana. | 🟢 Corrigido |
| 07/08/2026 09:58 | Módulo 01 | `port-forward` + `curl` | `curl` falhou na fração de segundo antes do `port-forward` abrir. Adicionado `sleep 2` no `laboratorio.md` para tempo de abertura do túnel. | 🟢 Corrigido |
| 07/08/2026 10:05 | Módulo 01 | `port-forward service/quickstart-kb-http 5601` | Inacessível do navegador local via `localhost:5601` pois a VM é remota (Contabo). Adicionado `--address 0.0.0.0` no `laboratorio.md`. | 🟢 Corrigido |
| 07/08/2026 10:08 | Módulo 01 | Validação final do Kibana e port-forward | `--address 0.0.0.0` confirmado como universal (funciona em VM remota, VM local e Ubuntu bare-metal). | 🟢 OK |
| 07/08/2026 10:11 | Módulo 01 | `curl -k -u "elastic:$PASSWORD" https://localhost:9200` | Elasticsearch respondeu com sucesso (`version: 9.4.2`, `tagline: You Know, for Search`). | 🟢 OK |
| 07/08/2026 10:11 | Módulo 01 | `--address 0.0.0.0 service/quickstart-kb-http 5601` | Conexões recebidas com sucesso no Kibana (`Handling connection for 5601`). | 🟢 OK |
| 07/08/2026 10:11 | Módulo 01 | Checklist final de validação | Nó `eck-lab` (Ready), `elastic-operator-0` (Running), 12 CRDs e clusters ES/KB com HEALTH `green`. | 🟢 OK |
| 07/08/2026 10:14 | Módulo 02 | `get elasticsearch,statefulset...` (Passo 1-3) | Inspeção dos objetos criados pelo operator (16 secrets, PVC 20GB, StatefulSet). Teste de deleção de pod (`delete pod`) iniciado. | 🟢 OK |
| 07/08/2026 10:25 | Módulo 02 | Reconciliação do pod (Passo 3) | Pod `quickstart-es-default-0` deletado, recriado automaticamente pelo StatefulSet (Pending → Init → Running). Autocura validada. | 🟢 OK |
| 07/08/2026 10:25 | Módulo 02 | `kubectl apply -n elastic -f manifests/...` (Passo 4) | Cluster `lab-es` e `lab-kb` criados com sucesso. Pods subindo normalmente. | 🟢 OK |
| 07/08/2026 10:25 | Módulo 02 | `port-forward service/lab-es-es-http 9200 &` (Passo 5) | Erro `address already in use` (port-forward do Módulo 01 ainda ativo). Corrigido com `pkill -f "port-forward" || true`. | 🟢 Corrigido |
| 07/08/2026 10:25 | Módulo 02 | `/_cluster/health` (Passo 5 — após pkill) | Cluster `lab-es` respondeu com `status: green`, 43 shards ativos, 0 não-atribuídos. | 🟢 OK |
| 07/08/2026 10:41 | Módulo 02 | `curl --cacert ca.crt https://localhost:9200` (Passo 6) | Erro `SSL: no alternative certificate subject name matches target host name 'localhost'`. Comportamento correto de TLS: cert assinado para hostnames internos do K8s, não para `localhost`. Documentado no guia com `--resolve` como alternativa. | 🟢 Documentado |
| 07/08/2026 10:42 | Módulo 02 | `openssl + curl --resolve` (Passo 6) | Erro `syntax error near unexpected token newline`: comandos dentro de blockquote Markdown copiados com `> ` que o bash interpretou como redirecionamento. Corrigido no guia — comandos movidos para blocos de código independentes em linha única. | 🟢 Corrigido |
| 07/08/2026 10:44 | Módulo 02 | `openssl` + `curl --cacert --resolve` (Passo 6) | SANs confirmados: `lab-es-es-http.elastic.svc`, `*.lab-es-es-default.elastic.svc`, etc. TLS validado com CA sem `-k` — cluster `lab-es` respondeu com `name: lab-es-es-default-0`. | 🟢 OK |
| 07/08/2026 11:02 | Módulo 02 | `port-forward service/lab-kb-http 5601` (Passo 7) | Erro `services "lab-kb-http" not found`. O operador ECK nomeou o serviço como `lab-kb-kb-http`. Ajustado no `laboratorio.md`. | 🟢 Corrigido |
| 07/08/2026 11:03 | Módulo 02 | `port-forward service/lab-kb-kb-http 5601` (Passo 7) | Túnel aberto na porta 5601 (0.0.0.0). Acesso ao Kibana estabelecido. | 🟢 OK |
| 07/08/2026 11:05 | Módulo 02 | Checklist final (`get elasticsearch, kibana`) | Recursos `lab-es` e `lab-kb` retornaram HEALTH `green`. | 🟢 OK |
| 07/08/2026 11:14 | Módulo 02 | `curl ... _cat/indices | grep sample` (Passo 8) | Ingestão dos dados de amostra confirmada (`kibana_sample_data_ecommerce` com 4.675 docs). | 🟢 OK |
| 07/08/2026 11:38 | Módulo 03 | Ajuste do bloco de inicialização do terminal | Substituído o comando original por bloco resiliente (`pkill -f "port-forward.*9200" || true` + `sleep 2`) para garantir liberação de porta e estabilidade do túnel antes de requisições. | 🟢 Corrigido |
| 07/08/2026 11:40 | Módulo 03 | Validação dos Passos 1 a 9 | Os Passos 1 ao 9 não foram executados via terminal (`curl`). A validação do módulo foi realizada exclusivamente na interface do Kibana Dev Tools utilizando o lote de consultas em `exemplos/consultas-dev-tools.txt`, com todas as buscas retornando HTTP 200. | 🟢 OK |
| 07/08/2026 14:26 | Módulo 04 | Inicialização (Pré-requisitos) | Erro `secrets not found` indicou ausência do cluster `lab-es`. Adicionada Etapa 0 no início do laboratório para garantir de forma idempotente que o cluster do Módulo 02 esteja em execução antes de capturar senhas. | 🟢 Corrigido |
| 07/08/2026 14:32 | Módulo 04 | Passo 3 (Criar índice loja) | Erro HTTP 405 (`Incorrect HTTP method for uri [/]`) causado pela estrutura do `alias es` no `curl`[cite: 2]. Atualizado o `laboratorio.md` para utilizar chamadas `curl` explícitas[cite: 1, 2]. | 🟢 Corrigido |
| 07/08/2026 14:40 | Módulo 04 | Passo 4 (Corrigir em single-node) | Erro HTTP 405 ao tentar alterar réplicas usando `alias es`[cite: 2]. Atualizado o `laboratorio.md` para chamada `curl` explícita[cite: 1]. | 🟢 Corrigido |
| 07/08/2026 14:42 | Módulo 04 | Passo 5 (Cluster 2 nós) | Erro `path "manifests/topo-es.yaml" does not exist`. Adicionada a criação automática do manifesto via HEREDOC no `laboratorio.md`. | 🟢 Corrigido |
| 07/08/2026 14:48 | Módulo 04 | Passo 6 (Criar índice loja2 no topo-es) | Erro HTTP 405 ao tentar criar `loja2` usando `alias es2`. Atualizado o `laboratorio.md` para chamada `curl` explícita na porta 9201[cite: 1]. | 🟢 Corrigido |
| 07/08/2026 14:55 | Módulo 04 | Passo 9 (Forcemerge de segmentos no loja2) | Erro HTTP 405 ao executar `_forcemerge` usando `alias es2`[cite: 1]. Atualizado o `laboratorio.md` para chamada `curl` explícita na porta 9201[cite: 1]. | 🟢 Corrigido |
| 07/08/2026 15:00 | Módulo 04 | Voltar ao ambiente base (Limpeza) | Erro `path "../02-deploy-elastic-stack-eck/manifests/elasticsearch.yaml" does not exist`[cite: 1]. Atualizado o roteiro do laboratório para o caminho local `manifests/elasticsearch.yaml`[cite: 1]. | 🟢 Corrigido |

---

## Progresso dos Módulos

- [x] **Módulo 00:** Preparação de Ambiente
- [x] **Módulo 01:** Instalação do Kubernetes & ECK
- [x] **Módulo 02:** Deploy Elastic Stack via ECK
- [x] **Módulo 03:** Query DSL
- [x] **Módulo 04:** Nós, Shards e Segments
- [ ] **Módulo 05:** Index Settings, Mapping & Analyzers
- [ ] **Módulo 06:** Ingestão de Dados & Elastic Agent
- [ ] **Módulo 07:** Kibana & Dashboards
- [ ] **Módulo 08:** Index Lifecycle Management (ILM)
- [ ] **Módulo 09:** Machine Learning
- [ ] **Módulo 10:** Migração & Upgrade Declarativo
- [ ] **Módulo 11:** Capacity Planning
- [ ] **Módulo 12:** Elastic GenAI