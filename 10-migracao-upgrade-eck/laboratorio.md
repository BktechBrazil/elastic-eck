# Laboratório 10 — Upgrade do Stack pelo Operator

> **Pré-requisito:** Módulo 02 (`lab-es` + `lab-kb` na versão 9.4.2).
> **Tempo estimado:** 25–35 minutos.

```bash
source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
```

Confira a versão atual:

```bash
es "/?pretty" | grep number      # "number" : "9.4.2"
```

---

## Parte A — Cuidados antes do upgrade

### Passo 1 — Upgrade Assistant (deprecations)

No **Kibana → Stack Management → Upgrade Assistant**, veja se há **deprecations**. Para um patch (9.4.2→9.4.4) deve estar limpo; antes de um major, resolva os itens críticos aqui.

### Passo 2 — Snapshot (rede de segurança)

Registre um repositório de filesystem e tire um snapshot. (No lab single-node usamos um caminho local; em produção use S3/GCS.)

```text
# Dev Tools — registrar repositório (requer path.repo configurado; ver nota abaixo)
PUT _snapshot/lab_backup
{ "type": "fs", "settings": { "location": "/usr/share/elasticsearch/data/snapshots" } }

PUT _snapshot/lab_backup/antes-upgrade?wait_for_completion=true
```

> **Nota:** o repositório `fs` exige `path.repo` no `elasticsearch.yml`. No ECK, adicione em `spec.nodeSets[].config: path.repo: ["/usr/share/elasticsearch/data/snapshots"]`. Para o lab, o objetivo é entender o **fluxo**; o snapshot em si é opcional aqui.

## Parte B — Atualizar o Elasticsearch

### passo 3 - Criar o arquivo elasticsearch-9.4.4.yaml (caso não exista)
```bash
mkdir -p manifests
cat << 'EOF' > manifests/elasticsearch-9.4.4.yaml
# lab-es atualizado para 9.4.4 (Módulo 10). Idêntico ao do Módulo 02,
# apenas com spec.version alterado. Aplique e o operator faz o rolling upgrade.
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: lab-es
spec:
  version: 9.4.4          # <-- era 9.4.2
  nodeSets:
    - name: default
      count: 1
      config:
        node.store.allow_mmap: true
      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              env:
                - name: ES_JAVA_OPTS
                  value: -Xms2g -Xmx2g
              resources:
                requests: { memory: 4Gi, cpu: "1" }
                limits:   { memory: 4Gi }
      volumeClaimTemplates:
        - metadata: { name: elasticsearch-data }
          spec:
            accessModes: [ReadWriteOnce]
            resources: { requests: { storage: 20Gi } }
            storageClassName: local-path
EOF
```

### Passo 3.1 — Mudar a versão no CRD

O upgrade é só trocar `spec.version`. Aplique o manifesto já preparado (9.4.4):

```bash
kubectl apply -n elastic -f manifests/elasticsearch-9.4.4.yaml
```

### Passo 4 — Acompanhar o rolling upgrade

```bash
kubectl -n elastic get pods -l elasticsearch.k8s.elastic.co/cluster-name=lab-es -w
kubectl -n elastic get elasticsearch lab-es      # HEALTH volta a green após a troca
```

Você **não executa** nada além do apply — o operator recria o pod com a imagem nova e espera o cluster estabilizar. Em single-node há uma breve indisponibilidade; em multi-nó o serviço segue no ar.

### Passo 5 — Validar

```bash
es "/?pretty" | grep number      # agora "9.4.4"
```

## Parte C — Atualizar o Kibana (depois do ES)

### Passo 6 — Aplicar o Kibana 9.4.4

```bash
kubectl apply -n elastic -f manifests/kibana-9.4.4.yaml
kubectl -n elastic get kibana lab-kb -w          # aguarde green
```

> Ordem obrigatória: **ES primeiro, Kibana depois**. O Kibana nunca deve ficar mais novo que o ES.

## Parte D — (Opcional) Atualizar o operator

```bash
helm repo update
helm search repo elastic/eck-operator --versions | head
# helm upgrade elastic-operator elastic/eck-operator -n elastic-system --version <nova>
```

Atualizar o operator não mexe nos seus clusters — só amplia o suporte e traz correções.

---

## ✅ Você aprendeu

- Que no ECK o upgrade é **declarativo**: mude `spec.version` e o operator faz o **rolling upgrade**.
- A **ordem** correta: operator → Elasticsearch → Kibana → coletores.
- Os **cuidados prévios**: Upgrade Assistant (deprecations), snapshot e leitura de breaking changes.
- A diferença entre atualizar **o operator** (Helm) e atualizar **os clusters** (CRD).

➡️ **Módulo 11** — dimensionar o cluster: **Capacity Plan** com requests/limits e autoscaling.
