# Guia de Troubleshooting — Elastic Stack no ECK

Problemas comuns nos laboratórios e como resolvê-los. Consulte primeiro os eventos e o status do recurso:

```bash
kubectl -n elastic get elasticsearch,kibana
kubectl -n elastic describe elasticsearch quickstart
kubectl -n elastic get events --sort-by=.lastTimestamp | tail -20
```

---

## 1. Pod do Elasticsearch em `CrashLoopBackOff` logo no início

**Sintoma nos logs:** `max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]` (ou `[1048576]`).

**Causa:** o kernel do host não tem o `vm.max_map_count` ajustado.

**Correção (VM única):** aplique no host e torne persistente:

```bash
sudo sysctl -w vm.max_map_count=1048576
echo 'vm.max_map_count=1048576' | sudo tee /etc/sysctl.d/99-eck.conf
```

Depois reinicie o pod: `kubectl -n elastic delete pod <nome-do-pod-es>`.

---

## 2. PVC preso em `Pending`

**Sintoma:** `kubectl -n elastic get pvc` mostra `Pending`; o pod do ES não agenda.

**Causa:** não há **StorageClass default** com provisionamento dinâmico.

**Verificação e correção:**

```bash
kubectl get storageclass          # deve haver uma marcada como (default)
# se necessário, marque a local-path como default:
kubectl patch storageclass local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

---

## 3. Pod fica em `Pending` por falta de recursos

**Sintoma:** `describe pod` mostra `Insufficient memory` ou `Insufficient cpu`.

**Causa:** a soma de `requests` dos pods excede o que a VM tem.

**Correção:** reduza `resources.requests` no manifesto do ES/Kibana ou derrube cargas de outros módulos (ex.: pare o ML/GenAI antes). Confira o consumo:

```bash
kubectl top nodes
kubectl top pods -n elastic
```

> `kubectl top` exige o **metrics-server** (instalado no Módulo 01).

---

## 4. Recuperar a senha do usuário `elastic`

O operator gera a senha em um Secret:

```bash
kubectl -n elastic get secret quickstart-es-elastic-user \
  -o go-template='{{.data.elastic | base64decode}}'; echo
```

(Substitua `quickstart` pelo nome do seu recurso Elasticsearch.)

---

## 5. Acessar o Kibana / Elasticsearch localmente

```bash
# Kibana em https://localhost:5601
kubectl -n elastic port-forward service/quickstart-kb-http 5601

# Elasticsearch em https://localhost:9200
kubectl -n elastic port-forward service/quickstart-es-http 9200
```

O certificado é autoassinado no lab; use `-k` no `curl` ou aceite o aviso no navegador.

---

## 6. Erro de certificado TLS ao chamar o Elasticsearch

Use a CA gerada pelo operator em vez de `-k` para validar corretamente:

```bash
kubectl -n elastic get secret quickstart-es-http-certs-public \
  -o go-template='{{index .data "ca.crt" | base64decode}}' > /tmp/ca.crt
curl --cacert /tmp/ca.crt -u "elastic:$PASSWORD" https://localhost:9200
```

---

## 7. O operator não reconcilia (nada acontece após aplicar o YAML)

```bash
kubectl -n elastic-system get pods            # o pod do operator está Running?
kubectl -n elastic-system logs statefulset/elastic-operator | tail -40
```

Se o operator não estiver rodando, reinstale-o (Módulo 01). Confira também se as CRDs existem: `kubectl get crd | grep k8s.elastic.co`.

---

## 8. Cluster ES em estado `red`/`yellow`

- `yellow` em single-node é **esperado**: réplicas não têm um segundo nó para alocar. Nos labs, defina `index.number_of_replicas: 0` para índices de teste.
- `red` indica shard primário indisponível — verifique disco cheio (`kubectl top`/`df`), PVC e logs do pod.

```bash
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cluster/health?pretty
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cluster/allocation/explain?pretty
```

---

## 9. Disco cheio no host

Imagens de container e PVCs consomem os 100 GB. Limpe imagens não usadas:

```bash
sudo crictl rmi --prune      # containerd (kubeadm)
df -h /var/lib
```

---

## Comandos de diagnóstico rápido

```bash
kubectl get nodes -o wide
kubectl get pods -A | grep -vi running          # o que NÃO está Running
kubectl -n elastic get elasticsearch,kibana,pods,pvc,svc
kubectl -n elastic describe elasticsearch quickstart | sed -n '/Events/,$p'
```
