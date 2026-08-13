root@eck-lab:~# pwd
/root
root@eck-lab:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
root@eck-lab:~# mkdir -p manifests
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
EOF   curl -s http://localhost:11434/v1/modelsllama pull llama3.2:1b
root@eck-lab:~# kubectl apply -f manifests/ollama.yaml
persistentvolumeclaim/ollama-models created
deployment.apps/ollama created
service/ollama created
root@eck-lab:~# kubectl -n elastic rollout status deploy/ollama
Waiting for deployment "ollama" rollout to finish: 0 of 1 updated replicas are available...
deployment "ollama" successfully rolled out
root@eck-lab:~# kubectl -n elastic exec deploy/ollama -- ollama pull llama3.2:1b
pulling manifest
pulling 74701a8c35f6: 100% ▕█████████████████ ▏ 1.3 GB/1.3 GB   67 MB/s      0s
verifying sha256 digest
writing manifest
success
root@eck-lab:~# kubectl -n elastic exec deploy/ollama -- curl -s http://localhost:11434/v1/models
error: Internal error occurred: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "5d495eef6fd0770f56cda12d2e90e74975c1dbc42fc46a285e0a22170714d6d3": OCI runtime exec failed: exec failed: unable to start container process: exec: "curl": executable file not found in $PATH
root@eck-lab:~# kubectl -n elastic exec deploy/ollama -- ollama list
NAME           ID              SIZE      MODIFIED
llama3.2:1b    baf6a787fdff    1.3 GB    2 minutes ago
root@eck-lab:~# kubectl -n elastic port-forward service/ollama 11434:11434 &
[2] 1469207
root@eck-lab:~# Forwarding from 127.0.0.1:11434 -> 11434
Forwarding from [::1]:11434 -> 11434
^C
root@eck-lab:~# curl -s http://localhost:11434/v1/models
Handling connection for 11434
{"object":"list","data":[{"id":"llama3.2:1b","object":"model","created":1786647371,"owned_by":"library"}]}
root@eck-lab:~# kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-kb-http 5601:5601
Forwarding from 0.0.0.0:5601 -> 5601
Handling connection for 5601
Handling connection for 5601
root@eck-lab:~# kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'; echo
EtmaX9QjkxEqF9bwU2zMrhtM
root@eck-lab:~# kubectl -n elastic delete -f manifests/ollama.yaml
persistentvolumeclaim "ollama-models" deleted
deployment.apps "ollama" deleted
service "ollama" deleted