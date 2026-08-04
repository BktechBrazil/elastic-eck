# Laboratório 02 — Deploy consciente do Elastic Stack

> **Pré-requisito:** Módulo 01 concluído (operator + quickstart).
> **Tempo estimado:** 25–35 minutos.

```bash
source ../_assets/versions.env
```

---

## Parte A — Dissecar o que o operator criou

### Passo 1 — Ver todos os objetos do quickstart

```bash
kubectl -n elastic get elasticsearch,statefulset,pod,pvc,svc,secret | grep -i quickstart
```

Observe: um StatefulSet, um Pod, um PVC, dois Services (`-es-http` e `-es-transport`) e vários Secrets.

### Passo 2 — Ler a configuração efetiva e os eventos

```bash
kubectl -n elastic describe elasticsearch quickstart | sed -n '/Events/,$p'
kubectl -n elastic get elasticsearch quickstart -o yaml | less   # 'q' para sair
```

### Passo 3 — Provar a reconciliação

Apague o pod e veja o operator/StatefulSet recriá-lo:

```bash
kubectl -n elastic delete pod quickstart-es-default-0
kubectl -n elastic get pods -w      # o pod volta sozinho; Ctrl+C
```

---

## Parte B — Recriar como um cluster configurado (`lab-es`)

O quickstart é mínimo. Agora subimos um cluster nomeado com escolhas explícitas para o single-node (0 réplicas evita o estado `yellow`).

### Passo 4 — Aplicar o cluster do laboratório

```bash
kubectl apply -n elastic -f manifests/elasticsearch.yaml
kubectl apply -n elastic -f manifests/kibana.yaml
kubectl -n elastic get elasticsearch,kibana -w    # aguarde HEALTH green
```

### Passo 5 — Senha e acesso do `lab-es`

```bash
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user \
  -o go-template='{{.data.elastic | base64decode}}')
echo "Senha: $PASSWORD"

kubectl -n elastic port-forward service/lab-es-es-http 9200 &
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cluster/health?pretty
# status deve ser "green" (0 réplicas em single-node)
```

### Passo 6 — Validar TLS com a CA (sem `-k`)

```bash
kubectl -n elastic get secret lab-es-es-http-certs-public \
  -o go-template='{{index .data "ca.crt" | base64decode}}' > ca.crt
curl --cacert ca.crt -u "elastic:$PASSWORD" https://localhost:9200
```

---

## Parte C — Kibana + dados de amostra

### Passo 7 — Abrir o Kibana

```bash
kubectl -n elastic port-forward service/lab-kb-http 5601
# navegador: https://localhost:5601  (elastic / $PASSWORD)
```

### Passo 8 — Carregar os "Sample data"

No Kibana: **☰ Menu → Integrations** (ou a página inicial) **→ "Add sample data"** e adicione **Sample eCommerce orders** e **Sample web logs**. Esses conjuntos serão usados nos Módulos 03, 05 e 07.

**Validação:**

```bash
curl -k -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices?v" | grep kibana_sample
```

---

## ✅ Checklist do módulo

```bash
kubectl -n elastic get elasticsearch lab-es          # HEALTH green
kubectl -n elastic get kibana lab-kb                 # HEALTH green
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cat/indices?v | grep sample
```

Você entende agora o que o operator cria e como configurar um cluster de forma consciente. No **Módulo 03** vamos explorar esses dados com a Query DSL.

> **Nota de recursos:** manter *dois* clusters (quickstart + lab-es) pode pesar em 16 GB. Se quiser, remova o quickstart: `kubectl -n elastic delete elasticsearch quickstart && kubectl -n elastic delete kibana quickstart`.
