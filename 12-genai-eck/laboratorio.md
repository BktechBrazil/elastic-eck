# Laboratório 12 — GenAI: Playground e Agent Builder com LLM Local

> **Pré-requisito:** Módulos 02 e 07. **Módulo mais pesado — rode isolado; ideal 32 GB.**
> **Tempo estimado:** 45–60 minutos.

```bash
source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

---

## Parte A — Subir o LLM local

### Passo 1 — Ollama no cluster
Caso não tenha o ollama.yaml, cole com este comando:
```bash
mkdir -p manifests
cat << 'EOF' > manifests/ollama.yaml
# LLM local (Ollama) rodando NO cluster — expõe API compatível com OpenAI (Módulo 12).
# Endpoint p/ o conector do Kibana: http://ollama.elastic.svc:11434/v1
# ATENÇÃO (16 GB): pesado. Use modelo pequeno (llama3.2:1b). Ideal 32 GB. Rode isolado.
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ollama-models
  namespace: elastic
spec:
  accessModes: [ReadWriteOnce]
  resources:
    requests:
      storage: 15Gi
  storageClassName: local-path
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama
  namespace: elastic
  labels: { app: ollama }
spec:
  replicas: 1
  selector:
    matchLabels: { app: ollama }
  template:
    metadata:
      labels: { app: ollama }
    spec:
      containers:
        - name: ollama
          image: ollama/ollama:latest
          ports:
            - containerPort: 11434
          env:
            - name: OLLAMA_HOST
              value: "0.0.0.0"
          resources:
            requests:
              memory: 3Gi
              cpu: "2"
            limits:
              memory: 5Gi
          volumeMounts:
            - name: models
              mountPath: /root/.ollama
      volumes:
        - name: models
          persistentVolumeClaim:
            claimName: ollama-models
---
apiVersion: v1
kind: Service
metadata:
  name: ollama
  namespace: elastic
spec:
  selector: { app: ollama }
  ports:
    - port: 11434
      targetPort: 11434
  type: ClusterIP
# Depois de subir, baixe um modelo pequeno:
#   kubectl -n elastic exec deploy/ollama -- ollama pull llama3.2:1b
# Teste a API OpenAI-compatível:
#   kubectl -n elastic exec deploy/ollama -- \
#     curl -s http://localhost:11434/v1/models
EOF
```

```bash
kubectl apply -f manifests/ollama.yaml
kubectl -n elastic rollout status deploy/ollama
# baixar um modelo pequeno:
kubectl -n elastic exec deploy/ollama -- ollama pull llama3.2:1b
# validar a API compatível com OpenAI:
# Abra o túnel de porta:
kubectl -n elastic port-forward service/ollama 11434:11434 &
# Execute o curl:
curl -s http://localhost:11434/v1/models
```

> Alternativa mais leve: rode **Ollama/LM Studio na própria VM host** e aponte o conector para `http://<IP-do-host>:11434`. Assim o LLM não disputa os limites do cluster.

## Parte B — Trial e conector

### Passo 2 — Ativar o trial

Se ainda não ativou (Módulo 09): **Stack Management → License Management → Start a 30-day trial** (ou `POST _license/start_trial?acknowledge=true`).

### Passo 3 — Criar o conector OpenAI → LLM local

Siga [`manifests/conector-openai.md`](manifests/conector-openai.md): crie o conector `llm-local` apontando para `http://ollama.elastic.svc:11434/v1/chat/completions`, modelo `llama3.2:1b`.

## Parte C — Playground (RAG)

### Passo 4 — Indexar documentos de exemplo

No **Dev Tools**, crie um índice de conhecimento simples:

```text
POST base-conhecimento/_bulk
{"index":{}}
{"titulo":"Política de troca","texto":"Trocas em até 30 dias com nota fiscal."}
{"index":{}}
{"titulo":"Prazo de entrega","texto":"Entrega em 3 a 7 dias úteis para todo o Brasil."}
{"index":{}}
{"titulo":"Garantia","texto":"Todos os produtos têm 12 meses de garantia do fabricante."}
```

### Passo 5 — Conversar com os dados

Abra **Menu → Playground** → selecione o modelo **`llm-local`** → adicione o índice **`base-conhecimento`**. Pergunte, por exemplo:

> "Qual é o prazo de troca e o de entrega?"

O Playground **recupera** os trechos relevantes e o **LLM local** responde fundamentado neles. Explore o botão que mostra a **query** de recuperação e o **código** gerado.

> **Evolução:** para recuperação **semântica**, crie um campo `semantic_text` e um *inference endpoint* (ELSER ou embeddings) — mais preciso, porém mais pesado. Fica como próximo passo.

## Parte D — Agent Builder (agente)

### Passo 6 — Criar um agente

Abra **Menu → Agent Builder** (nas versões recentes; é a evolução GA do Playground). Crie um **agente** que use o modelo `llm-local` e uma **tool de busca** sobre `base-conhecimento`. Converse com o agente pela interface de chat e observe-o **decidir** usar a tool para responder.

> Conforme a versão, o Agent Builder pode estar em Technical Preview/GA e exigir habilitar em configurações. Se não aparecer, use o Playground (Parte C) — o conceito de RAG com LLM local é o mesmo.

## Parte E — Encerramento e limpeza

```bash
kubectl -n elastic delete -f manifests/ollama.yaml    # libera bastante RAM
```

---

## ✅ Você aprendeu

- O conceito de **RAG**: recuperar no Elasticsearch e gerar com o LLM, fundamentando a resposta.
- A conectar um **LLM local** via **conector OpenAI** — sem LocalAI, sem nuvem.
- A usar o **Playground** para conversar com índices e o **Agent Builder** para criar agentes com tools.
- Que, no ECK **self-managed**, o LLM é **sempre** por conector — e o **LLM local** é o caminho natural.

🎓 **Parabéns — você concluiu o curso "Elastic Stack Total — Edição ECK"!** Do cluster Kubernetes do zero (Módulo 01) ao GenAI com LLM local (Módulo 12).

> **Próximos passos:** semantic search com `semantic_text`/ELSER, observabilidade e segurança com Elastic Agent/Fleet, e produção real (hot-warm, autoscaling, snapshots em object storage).
