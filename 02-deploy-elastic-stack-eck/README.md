# Módulo 02 — Deploy do Elastic Stack no ECK

> **Objetivo:** entender a fundo o que o operator cria a partir de um recurso `Elasticsearch`, e evoluir do "quickstart" para um cluster configurado de forma consciente — `nodeSets`, recursos, TLS, segredos e formas de acesso. Este módulo **substitui** a antiga instalação por pacotes/tarball.

> **Pré-requisito:** Módulo 01 (cluster + operator + quickstart no ar).

---

## 1. A mudança de paradigma

No curso original, instalar o Elastic Stack era: baixar o pacote, editar `elasticsearch.yml`, abrir portas, configurar TLS na mão, criar usuários, repetir para cada nó. No ECK, **tudo isso vira um documento YAML declarativo**, e o operator executa e mantém.

Quando você aplicou o `elasticsearch-quickstart.yaml` no Módulo 01, o operator criou silenciosamente um conjunto de objetos. Entender esse conjunto é entender o ECK.

## 2. O que o operator cria (dissecando o quickstart)

A partir de um recurso `Elasticsearch` chamado `quickstart`, o operator gera:

| Objeto Kubernetes | Nome (padrão) | Função |
|---|---|---|
| **StatefulSet** | `quickstart-es-default` | Controla os pods do ES do `nodeSet` "default", com identidade e disco estáveis |
| **Pod(s)** | `quickstart-es-default-0` | O(s) nó(s) Elasticsearch de fato |
| **PVC** | `elasticsearch-data-quickstart-es-default-0` | Disco durável dos dados |
| **Service** | `quickstart-es-http` | Endpoint HTTPS do cluster (porta 9200) |
| **Service** | `quickstart-es-transport` | Comunicação interna entre nós (porta 9300) |
| **Secret** | `quickstart-es-elastic-user` | Senha do superusuário `elastic` |
| **Secret** | `quickstart-es-http-certs-public` | Certificado TLS (CA pública) do HTTP |
| **ConfigMap/Secret** | vários | Configuração efetiva de cada nó |

Explore com:

```bash
kubectl -n elastic get statefulset,pod,pvc,svc,secret | grep quickstart
```

> **Insight:** você nunca cria esses objetos à mão. Você descreve o *desejo* (`Elasticsearch`), e o operator materializa e reconcilia o resto. Se você apagar um pod, ele volta; se mudar o YAML, ele converge.

## 3. Anatomia de um recurso Elasticsearch

O bloco central é o **`nodeSets`** — uma lista de "grupos de nós" com a mesma configuração. Cada `nodeSet` tem:

- **`count`** — quantos nós daquele grupo.
- **`config`** — vai direto para o `elasticsearch.yml` de cada nó (ex.: papéis do nó `node.roles`, `node.store.allow_mmap`).
- **`podTemplate`** — personaliza o pod: recursos (CPU/memória), heap da JVM (`ES_JAVA_OPTS`), afinidade, tolerâncias.
- **`volumeClaimTemplates`** — o(s) disco(s) PVC de cada nó.

Um cluster com papéis separados (que veremos no Módulo 04) é só uma lista com vários `nodeSets` — um para *master*, um para *data*, etc.

## 4. Segurança que vem "de graça"

O ECK **liga segurança por padrão**: TLS em toda a comunicação (HTTP e transport), certificados gerados e rotacionados por uma CA interna, e a senha do `elastic` num Secret. Em produção você troca a CA pela sua e conecta a um provedor de identidade; no lab, usamos o que o operator gera.

Recuperar a senha e a CA:

```bash
# senha
kubectl -n elastic get secret quickstart-es-elastic-user \
  -o go-template='{{.data.elastic | base64decode}}'; echo
# CA pública (para validar o TLS sem -k)
kubectl -n elastic get secret quickstart-es-http-certs-public \
  -o go-template='{{index .data "ca.crt" | base64decode}}' > ca.crt
```

## 5. Formas de acesso

- **`port-forward`** (lab): túnel do seu terminal até o Service. Simples, sem expor nada na rede.
- **`NodePort` / `LoadBalancer`**: expõem o Service fora do cluster (mais comum em produção).
- **`Ingress`**: um roteador HTTP(S) com nome de host. Fora do escopo do lab single-node, mas citado para contexto.

## 6. O que você faz no laboratório

Você vai (a) dissecar o quickstart, (b) recriar o cluster como **`lab-es`** com configuração consciente para single-node (réplicas 0, heap explícito), (c) subir o Kibana ligado a ele, (d) carregar os **dados de amostra** do Kibana, que servirão de base para os módulos de consulta e visualização.

---

➡️ [**Laboratório**](laboratorio.md) · [`manifests/`](manifests/) · [`slides.html`](slides.html)
