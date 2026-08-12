# Laboratório 09 — Detecção de Anomalias com Elastic ML

> **Pré-requisito:** Módulos 02 e 07 (Sample data + Kibana).
> **Tempo estimado:** 30–40 minutos.
> **⚠️ Recursos:** módulo pesado. Pare coletores do Módulo 06 e outros clusters. Ideal subir a VM para 32 GB.

```bash
source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

---

## Parte A — Habilitar ML

### Passo 1 — Ativar o papel `ml` no cluster

Aplique a nova configuração no cluster para habilitar o papel de Machine Learning (`ml`) e expandir os recursos de memória.

1. **Criar o arquivo do manifesto `lab-es-ml.yaml`:**

```bash
mkdir -p manifests
cat << 'EOF' > manifests/lab-es-ml.yaml
# Cluster do lab com o papel de nó "ml" habilitado (Módulo 09).
# Heap e memória maiores porque ML consome RAM ALÉM do heap da JVM.
# ATENÇÃO (16 GB): rode isolado; pare coletores/outros clusters antes.
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: lab-es
spec:
  version: 9.4.2
  nodeSets:
    - name: default
      count: 1
      config:
        # 'ml' habilita jobs de Machine Learning neste nó.
        node.roles: ["master", "data", "ingest", "ml", "remote_cluster_client"]
        node.store.allow_mmap: true
      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              env:
                - name: ES_JAVA_OPTS
                  value: -Xms3g -Xmx3g          # heap 3 GB
              resources:
                requests:
                  memory: 6Gi                    # 6 GB: heap (3G) + ML + overhead
                  cpu: "2"
                limits:
                  memory: 6Gi
      volumeClaimTemplates:
        - metadata: { name: elasticsearch-data }
          spec:
            accessModes: [ReadWriteOnce]
            resources: { requests: { storage: 20Gi } }
            storageClassName: local-path
EOF

2. **Aplicar o manifesto e monitorar a reconciliação do cluster:**

```bash
kubectl apply -n elastic -f manifests/lab-es-ml.yaml
kubectl -n elastic get elasticsearch lab-es -w
```

3. **(Opcional) Acompanhar a reinicialização do Pod do Elasticsearch:**

```bash
kubectl -n elastic get pods -l elasticsearch.k8s.elastic.co/cluster-name=lab-es -w
```

### Passo 2 — Iniciar o trial de 30 dias

ML exige licença Platinum/Enterprise. Ative o trial:

- **Kibana → Stack Management → License Management → "Start a 30-day trial"**, ou via Dev Tools:

```text
POST _license/start_trial?acknowledge=true
```

Confirme:

```text
GET _license
# "type": "trial", "status": "active"
```

## Parte B — Criar um job de anomalia

### Passo 3 — Garantir dados

Use os web logs de amostra (`kibana_sample_data_logs`). Se necessário, recarregue-os (Módulo 02). Ajuste o intervalo de tempo do Kibana para cobrir os dados.

### Passo 4 — Assistente Single Metric

**Kibana → Machine Learning → Anomaly Detection → Create job → Selecione o Data View `kibana_sample_data_logs` → "Single metric"**.

- **Aggregation/Field:** `Count` (contagem de eventos — o volume de requisições).
- **Bucket span:** `15m`.
- Avance, nomeie o job (ex.: `web-logs-volume`) e **crie + inicie** (rode em modo real-time ou sobre o histórico).

### Passo 5 — Explorar as anomalias

Abra o **Single Metric Viewer** e o **Anomaly Explorer**:
- A linha mostra o volume real e a **banda de normalidade** que o ML aprendeu.
- Pontos coloridos = anomalias, com **score** (0–100). Clique para ver o valor esperado × observado.

> Os Sample data têm picos plantados — você deverá ver anomalias destacadas.

## Parte C — (Opcional) Multi-metric por entidade

### Passo 6 — Job multi-metric

Crie outro job "Multi-metric" com:
- **Detector:** `Count`.
- **Split field (by):** `geo.dest` (uma linha de base por país de destino).

Assim o ML aprende o "normal" **por entidade** e acha anomalias específicas de cada país.

---

## ✅ Você aprendeu

- As duas famílias do Elastic ML: **anomaly detection** (séries temporais) e **data frame analytics**.
- Que ML exige licença **Platinum/Enterprise** (use o **trial**).
- Os conceitos de **bucket span**, **detector** e **partition/by field**.
- Que no ECK basta habilitar o papel de nó **`ml`** (e reservar RAM — ML consome memória **além do heap**).

> **Voltar ao cluster leve:** reaplique o `../02-deploy-elastic-stack-eck/manifests/elasticsearch.yaml` para liberar RAM.

➡️ **Módulo 10** — atualizar o Stack sem downtime: **migração/upgrade** pelo operator.
