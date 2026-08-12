# Laboratório 06 — Ingestão com Beats, Logstash e Elastic Agent

> **Pré-requisito:** Módulo 02 (`lab-es` + `lab-kb` no ar).
> **Tempo estimado:** 40–50 minutos.
> **Recursos:** rode **um coletor de cada vez** e remova o anterior antes do próximo (16 GB).

```bash
source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

Confirme que o operator gerencia a ingestão:

```bash
kubectl get crd | grep -E 'beats|agents|logstashes'
```

---

## Lab A — Filebeat (CRD `Beat`) coletando logs de containers

### Passo 1 - criar o manifest/filebeat.yaml (caso não tenha)

```bash
mkdir -p manifests
cat << 'EOF' > manifests/filebeat.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
  - apiGroups: ["apps"]
    resources: ["replicasets"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat
subjects:
  - kind: ServiceAccount
    name: filebeat
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  elasticsearchRef:
    name: lab-es
  kibanaRef:
    name: lab-kb
  config:
    filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
    processors:
      - add_kubernetes_metadata:
          host: ${NODE_NAME}
          matchers:
            - logs_path:
                logs_path: "/var/log/containers/"
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat
        automountServiceAccountToken: true
        terminationGracePeriodSeconds: 30
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
        securityContext:
          runAsUser: 0
        containers:
          - name: filebeat
            resources:
              requests:
                memory: 200Mi
                cpu: 100m
              limits:
                memory: 300Mi
            env:
              - name: NODE_NAME
                valueFrom:
                  fieldRef:
                    fieldPath: spec.nodeName
            volumeMounts:
              - name: varlogcontainers
                mountPath: /var/log/containers
              - name: varlogpods
                mountPath: /var/log/pods
              - name: varlibdockercontainers
                mountPath: /var/lib/docker/containers
        volumes:
          - name: varlogcontainers
            hostPath:
              path: /var/log/containers
          - name: varlogpods
            hostPath:
              path: /var/log/pods
          - name: varlibdockercontainers
            hostPath:
              path: /var/lib/docker/containers
EOF
```

### Passo 1.1 — Aplicar o Filebeat (DaemonSet)

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

### Passo 4 criar o manifest/logstash.yaml (caso não exista)

```bash
mkdir -p manifests
cat << 'EOF' > manifests/logstash.yaml
# Logstash via CRD Logstash do ECK — pipeline central beats -> filtro -> elasticsearch
# O operator injeta as variáveis LAB_ES_ES_* a partir do elasticsearchRefs (clusterName: lab-es).
apiVersion: logstash.k8s.elastic.co/v1alpha1
kind: Logstash
metadata:
  name: lab-logstash
  namespace: elastic
spec:
  count: 1
  version: 9.4.2
  elasticsearchRefs:
    - name: lab-es
      clusterName: lab-es          # gera env: LAB_ES_ES_HOSTS, LAB_ES_ES_USER, LAB_ES_ES_PASSWORD, LAB_ES_ES_SSL_CERTIFICATE_AUTHORITY
  pipelines:
    - pipeline.id: main
      config.string: |
        input {
          beats { port => 5044 }
        }
        filter {
          mutate { add_field => { "[origem]" => "logstash-lab" } }
        }
        output {
          elasticsearch {
            hosts    => [ "${LAB_ES_ES_HOSTS}" ]
            user     => "${LAB_ES_ES_USER}"
            password => "${LAB_ES_ES_PASSWORD}"
            ssl_enabled                 => true
            ssl_certificate_authorities => "${LAB_ES_ES_SSL_CERTIFICATE_AUTHORITY}"
            index    => "logstash-lab-%{+YYYY.MM.dd}"
          }
        }
  # Service para os Beats enviarem eventos (porta 5044)
  services:
    - name: beats
      service:
        spec:
          type: ClusterIP
          ports:
            - port: 5044
              name: filebeat
              protocol: TCP
              targetPort: 5044
  podTemplate:
    spec:
      containers:
        - name: logstash
          resources:
            requests:
              memory: 1Gi
              cpu: 500m
            limits:
              memory: 1536Mi

EOF
```

### Passo 4.1 — Subir o Logstash (CRD `Logstash`)

```bash
kubectl apply -f manifests/logstash.yaml
kubectl -n elastic get logstash lab-logstash    # aguarde disponível
kubectl -n elastic get svc | grep lab-logstash  # note o service lab-logstash-ls-beats:5044
```

O pipeline (`input beats → filter mutate → output elasticsearch`) usa as variáveis `LAB_ES_ES_*` que o operator injetou a partir do `elasticsearchRefs`.

### Passo 5.0 - Criar o manifesto/filebeat-para-logstash.yaml (caso não exista)
#### Criado em base 64 para que não haja erro de truncamento 

```bash
echo "YXBpVmVyc2lvbjogdjEKa2luZDogU2VydmljZUFjY291bnQKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKICBuYW1lc3BhY2U6IGVsYXN0aWMKLS0tCmFwaVZlcnNpb246IHJiYWMuYXV0aG9yaXphdGlvbi5rOHMuaW8vdjEKa2luZDogQ2x1c3RlclJvbGUKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKcnVsZXM6CiAgLSBhcGlHcm91cHM6IFsiIl0KICAgIHJlc291cmNlczogWyJuYW1lc3BhY2VzIiwgInBvZHMiLCAibm9kZXMiXQogICAgdmVyYnM6IFsiZ2V0IiwgIndhdGNoIiwgImxpc3QiXQotLS0KYXBpVmVyc2lvbjogcmJhYy5hdXRob3JpemF0aW9uLms4cy5pby92MQpraW5kOiBDbHVzdGVyUm9sZUJpbmRpbmcKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKc3ViamVjdHM6CiAgLSBraW5kOiBTZXJ2aWNlQWNjb3VudAogICAgbmFtZTogZmlsZWJlYXQtbHMKICAgIG5hbWVzcGFjZTogZWxhc3RpYwpyb2xlUmVmOgogIGtpbmQ6IENsdXN0ZXJSb2xlCiAgbmFtZTogZmlsZWJlYXQtbHMKICBhcGlHcm91cDogcmJhYy5hdXRob3JpemF0aW9uLms4cy5pbwotLS0KYXBpVmVyc2lvbjogYmVhdC5rOHMuZWxhc3RpYy5jby92MWJldGExCmtpbmQ6IEJlYXQKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKICBuYW1lc3BhY2U6IGVsYXN0aWMKc3BlYzoKICB0eXBlOiBmaWxlYmVhdAogIHZlcnNpb246IDkuNC4yCiAgY29uZmlnOgogICAgZmlsZWJlYXQuaW5wdXRzOgogICAgICAtIHR5cGU6IGZpbGVzdHJlYW0KICAgICAgICBpZDogY29udGFpbmVyLWxvZ3MKICAgICAgICBwYXRoczoKICAgICAgICAgIC0gL3Zhci9sb2cvY29udGFpbmVycy8qLmxvZwogICAgICAgIHBhcnNlcnM6CiAgICAgICAgICAtIGNvbnRhaW5lcjoge30KICAgIG91dHB1dC5lbGFzdGljc2VhcmNoLmVuYWJsZWQ6IGZhbHNlCiAgICBvdXRwdXQubG9nc3Rhc2g6CiAgICAgIGhvc3RzOiBbImxhYi1sb2dzdGFzaC1scy1iZWF0czo1MDQ0Il0KICBkYWVtb25TZXQ6CiAgICBwb2RUZW1wbGF0ZToKICAgICAgc3BlYzoKICAgICAgICBzZXJ2aWNlQWNjb3VudE5hbWU6IGZpbGViZWF0LWxzCiAgICAgICAgYXV0b21vdW50U2VydmljZUFjY291bnRUb2tlbjogdHJ1ZQogICAgICAgIGhvc3ROZXR3b3JrOiB0cnVlCiAgICAgICAgZG5zUG9saWN5OiBDbHVzdGVyRmlyc3RXaXRoSG9zdE5ldAogICAgICAgIHNlY3VyaXR5Q29udGV4dDoKICAgICAgICAgIHJ1bkFzVXNlcjogMAogICAgICAgIGNvbnRhaW5lcnM6CiAgICAgICAgICAtIG5hbWU6IGZpbGViZWF0CiAgICAgICAgICAgIHJlc291cmNlczoKICAgICAgICAgICAgICByZXF1ZXN0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogMjAwTWkKICAgICAgICAgICAgICAgIGNwdTogMTAwbQogICAgICAgICAgICAgIGxpbWl0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogMzAwTWkKICAgICAgICAgICAgdm9sdW1lTW91bnRzOgogICAgICAgICAgICAgIC0gbmFtZTogdmFybG9nY29udGFpbmVycwogICAgICAgICAgICAgICAgbW91bnRQYXRoOiAvdmFyL2xvZy9jb250YWluZXJzCiAgICAgICAgICAgICAgLSBuYW1lOiB2YXJsb2dwb2RzCiAgICAgICAgICAgICAgICBtb3VudFBhdGg6IC92YXIvbG9nL3BvZHMKICAgICAgICB2b2x1bWVzOgogICAgICAgICAgLSBuYW1lOiB2YXJsb2djb250YWluZXJzCiAgICAgICAgICAgIGhvc3RQYXRoOgogICAgICAgICAgICAgIHBhdGg6IC92YXIvbG9nL2NvbnRhaW5lcnMKICAgICAgICAgIC0gbmFtZTogdmFybG9ncG9kcwogICAgICAgICAgICBob3N0UGF0aDoKICAgICAgICAgICAgICBwYXRoOiAvdmFyL2xvZy9wb2RzCg==" | base64 -d > manifests/filebeat-para-logstash.yaml
```

### Passo 5.1 — Apontar um Filebeat para o Logstash

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

### Passo 8.0 - Criar o manifesto/elastic-agent-standalone.yaml (caso não exista)
#### Criado em base 64 para que não haja erro de truncamento 

```bash
mkdir -p manifests
echo "IyBFbGFzdGljIEFnZW50IFNUQU5EQUxPTkUgdmlhIENSRCBBZ2VudCBkbyBFQ0sg4oCUIGNvbGV0YSBtw6l0cmljYXMgZG8gc2lzdGVtYSAoRGFlbW9uU2V0KS4KIyBBIGNvbmZpZ3VyYcOnw6NvIGRlIGNvbGV0YSB2aXZlIGVtIHNwZWMuY29uZmlnIChzZW0gRmxlZXQvVUkpLiBPIG9wZXJhdG9yIGNyaWEgYSBzYcOtZGEKIyAiZGVmYXVsdCIgYXV0b21hdGljYW1lbnRlIGEgcGFydGlyIGRvIGVsYXN0aWNzZWFyY2hSZWZzLgotLS0KYXBpVmVyc2lvbjogdjEKa2luZDogU2VydmljZUFjY291bnQKbWV0YWRhdGE6CiAgbmFtZTogZWxhc3RpYy1hZ2VudAogIG5hbWVzcGFjZTogZWxhc3RpYwotLS0KYXBpVmVyc2lvbjogcmJhYy5hdXRob3JpemF0aW9uLms4cy5pby92MQpraW5kOiBDbHVzdGVyUm9sZQptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CnJ1bGVzOgogIC0gYXBpR3JvdXBzOiBbIiJdCiAgICByZXNvdXJjZXM6IFsibm9kZXMiLCAibmFtZXNwYWNlcyIsICJwb2RzIiwgImV2ZW50cyIsICJzZXJ2aWNlcyJdCiAgICB2ZXJiczogWyJnZXQiLCAibGlzdCIsICJ3YXRjaCJdCiAgLSBhcGlHcm91cHM6IFsiYXBwcyJdCiAgICByZXNvdXJjZXM6IFsicmVwbGljYXNldHMiLCAiZGVwbG95bWVudHMiLCAiZGFlbW9uc2V0cyIsICJzdGF0ZWZ1bHNldHMiXQogICAgdmVyYnM6IFsiZ2V0IiwgImxpc3QiLCAid2F0Y2giXQogIC0gbm9uUmVzb3VyY2VVUkxzOiBbIi9tZXRyaWNzIl0KICAgIHZlcmJzOiBbImdldCJdCi0tLQphcGlWZXJzaW9uOiByYmFjLmF1dGhvcml6YXRpb24uazhzLmlvL3YxCmtpbmQ6IENsdXN0ZXJSb2xlQmluZGluZwptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CnN1YmplY3RzOgogIC0ga2luZDogU2VydmljZUFjY291bnQKICAgIG5hbWU6IGVsYXN0aWMtYWdlbnQKICAgIG5hbWVzcGFjZTogZWxhc3RpYwpyb2xlUmVmOgogIGtpbmQ6IENsdXN0ZXJSb2xlCiAgbmFtZTogZWxhc3RpYy1hZ2VudAogIGFwaUdyb3VwOiByYmFjLmF1dGhvcml6YXRpb24uazhzLmlvCi0tLQphcGlWZXJzaW9uOiBhZ2VudC5rOHMuZWxhc3RpYy5jby92MWFscGhhMQpraW5kOiBBZ2VudAptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CiAgbmFtZXNwYWNlOiBlbGFzdGljCnNwZWM6CiAgdmVyc2lvbjogOS40LjIKICBlbGFzdGljc2VhcmNoUmVmczoKICAgIC0gbmFtZTogbGFiLWVzICAgICAgICAgICMgY3JpYSBhIHNhw61kYSAiZGVmYXVsdCIgY29tIGhvc3QvY3JlZGVuY2lhaXMvQ0EgYXV0b21hdGljYW1lbnRlCiAgZGFlbW9uU2V0OgogICAgcG9kVGVtcGxhdGU6CiAgICAgIHNwZWM6CiAgICAgICAgc2VydmljZUFjY291bnROYW1lOiBlbGFzdGljLWFnZW50CiAgICAgICAgYXV0b21vdW50U2VydmljZUFjY291bnRUb2tlbjogdHJ1ZQogICAgICAgIHNlY3VyaXR5Q29udGV4dDoKICAgICAgICAgIHJ1bkFzVXNlcjogMAogICAgICAgIGNvbnRhaW5lcnM6CiAgICAgICAgICAtIG5hbWU6IGFnZW50CiAgICAgICAgICAgIHJlc291cmNlczoKICAgICAgICAgICAgICByZXF1ZXN0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogMzUwTWkKICAgICAgICAgICAgICAgIGNwdTogMTAwbQogICAgICAgICAgICAgIGxpbWl0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogNTAwTWkKICBjb25maWc6CiAgICBpZDogbGFiLWFnZW50CiAgICBhZ2VudDoKICAgICAgbW9uaXRvcmluZzoKICAgICAgICBlbmFibGVkOiB0cnVlCiAgICAgICAgdXNlX291dHB1dDogZGVmYXVsdAogICAgICAgIGxvZ3M6IHRydWUKICAgICAgICBtZXRyaWNzOiB0cnVlCiAgICBpbnB1dHM6CiAgICAgIC0gaWQ6IHN5c3RlbS1tZXRyaWNzCiAgICAgICAgdHlwZTogc3lzdGVtL21ldHJpY3MKICAgICAgICB1c2Vfb3V0cHV0OiBkZWZhdWx0CiAgICAgICAgZGF0YV9zdHJlYW06CiAgICAgICAgICBuYW1lc3BhY2U6IGRlZmF1bHQKICAgICAgICBzdHJlYW1zOgogICAgICAgICAgLSBpZDogY3B1CiAgICAgICAgICAgIGRhdGFfc3RyZWFtOiB7IGRhdGFzZXQ6IHN5c3RlbS5jcHUsIHR5cGU6IG1ldHJpY3MgfQogICAgICAgICAgICBtZXRyaWNzZXRzOiBbY3B1XQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogbWVtb3J5CiAgICAgICAgICAgIGRhdGFfc3RyZWFtOiB7IGRhdGFzZXQ6IHN5c3RlbS5tZW1vcnksIHR5cGU6IG1ldHJpY3MgfQogICAgICAgICAgICBtZXRyaWNzZXRzOiBbbWVtb3J5XQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogbmV0d29yawogICAgICAgICAgICBkYXRhX3N0cmVhbTogeyBkYXRhc2V0OiBzeXN0ZW0ubmV0d29yaywgdHlwZTogbWV0cmljcyB9CiAgICAgICAgICAgIG1ldHJpY3NldHM6IFtuZXR3b3JrXQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogZmlsZXN5c3RlbQogICAgICAgICAgICBkYXRhX3N0cmVhbTogeyBkYXRhc2V0OiBzeXN0ZW0uZmlsZXN5c3RlbSwgdHlwZTogbWV0cmljcyB9CiAgICAgICAgICAgIG1ldHJpY3NldHM6IFtmaWxlc3lzdGVtXQogICAgICAgICAgICBwZXJpb2Q6IDFtCg==" | base64 -d > manifests/elastic-agent-standalone.yaml
```

### Passo 8.1 — Subir o Agent (DaemonSet)

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
4. Lmebre de ter o arquivo **"fleet-referencia.yaml"** na máquina local e depois aplicar no cluster.

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
