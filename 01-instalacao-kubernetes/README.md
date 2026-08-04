# Módulo 01 — Instalação do Kubernetes + Operator ECK

> **Objetivo:** subir um cluster **Kubernetes puro (vanilla), single-node**, com `kubeadm`; configurar armazenamento dinâmico; instalar o **operator ECK** com Helm; e validar tudo com um Elasticsearch + Kibana "quickstart".

> **Pré-requisito:** ter concluído o [Módulo 00](../00-preparacao-ambiente/) (host preparado).

---

## 1. Kubernetes em 5 minutos (o essencial para o curso)

Kubernetes é um **orquestrador de containers**: você declara *o que* quer rodando (ex.: "3 réplicas deste container, com 4 GB cada, e este armazenamento"), e o Kubernetes trabalha para manter a realidade igual à declaração. Essa ideia — descrever o **estado desejado** e deixar o sistema convergir para ele — é o coração de tudo o que faremos.

Um cluster tem duas metades:

**Control plane** (o "cérebro"):
- **kube-apiserver** — a porta de entrada. Todo `kubectl` conversa com ele.
- **etcd** — o banco de dados que guarda o estado do cluster.
- **kube-scheduler** — decide em qual nó cada pod roda.
- **kube-controller-manager** — laços de controle que corrigem desvios do estado desejado.

**Nós de trabalho** (onde as cargas rodam):
- **kubelet** — o agente que roda em cada nó e conversa com o container runtime.
- **container runtime** (containerd) — de fato executa os containers.
- **kube-proxy / CNI** — dão rede aos pods.

No nosso lab, **um único nó acumula os dois papéis**. Por padrão o control plane recebe um *taint* (`node-role.kubernetes.io/control-plane`) que impede pods comuns de rodar nele; como só temos esse nó, vamos **remover o taint** para que ele também aceite cargas.

### Objetos que você vai usar o tempo todo
- **Pod** — a menor unidade; um ou mais containers que rodam juntos.
- **Namespace** — um "compartimento" lógico para organizar recursos (usaremos `elastic-system` e `elastic`).
- **PersistentVolumeClaim (PVC)** — um pedido de disco; o Elasticsearch usa PVCs para guardar os dados de forma durável.
- **StorageClass** — a "receita" que provisiona discos automaticamente para os PVCs.
- **Secret** — guarda dados sensíveis (senhas, certificados) que o operator gera para nós.

## 2. Por que um *operator*? (a peça-chave do ECK)

Instalar Elasticsearch é fácil; **operá-lo** é que é difícil: formar o cluster, gerar certificados TLS, rotacionar senhas, fazer *rolling upgrade* sem perder dados, escalar com segurança. Um **operator** é um software que empacota esse conhecimento operacional e roda *dentro* do Kubernetes.

O ECK estende o Kubernetes com **CRDs** (Custom Resource Definitions) — tipos de recurso novos como `Elasticsearch`, `Kibana`, `Agent`, `Beat`. A partir daí, criar um cluster Elasticsearch é tão simples quanto escrever um YAML de 10 linhas e rodar `kubectl apply`. O operator observa esse recurso e faz **todo o trabalho pesado**: cria os StatefulSets, os Services, os Secrets de TLS e a senha do usuário `elastic`, e mantém tudo saudável.

```
   você  ──apply──▶  recurso Elasticsearch (CRD)
                            │  o operator observa
                            ▼
   operator ECK ──cria──▶ StatefulSet · Service · Secret(TLS) · Secret(senha) · PVC
```

Esse é o salto conceitual do curso: **paramos de instalar software e passamos a declarar intenções.**

## 3. Ferramentas: `kubectl` e `helm`

- **`kubectl`** é o canivete suíço: aplica manifests (`apply`), inspeciona (`get`, `describe`), acompanha logs (`logs`), expõe portas (`port-forward`) e lê Secrets.
- **`helm`** é o "gerenciador de pacotes" do Kubernetes. Instalamos o operator ECK a partir do **chart oficial `eck-operator`** da Elastic — um comando instala e mantém versionado.

## 4. O caminho do laboratório

1. Instalar `kubeadm`, `kubelet`, `kubectl` e `helm`.
2. `kubeadm init` → inicializa o control plane.
3. Configurar o `kubeconfig` (credencial de acesso do `kubectl`).
4. Instalar o **CNI** (Calico) → dá rede aos pods.
5. Remover o *taint* do control plane → o nó passa a aceitar cargas.
6. Instalar uma **StorageClass** dinâmica (local-path) e o **metrics-server**.
7. Instalar o **operator ECK** com Helm.
8. **Validar** com um Elasticsearch + Kibana quickstart, pegar a senha e acessar o Kibana.

## 5. Resultado esperado

- `kubectl get nodes` → um nó `Ready`.
- `kubectl -n elastic-system get pods` → operator `Running`.
- `kubectl get crd | grep elastic` → CRDs `elasticsearch`, `kibana`, etc.
- Um Elasticsearch `green`/`yellow` e o Kibana acessível em `https://localhost:5601`.

Esse ambiente vira a **base reutilizada por todos os módulos seguintes**.

---

➡️ Faça agora o [**laboratório**](laboratorio.md) · Manifests em [`manifests/`](manifests/) · Slides: [`slides.html`](slides.html)
