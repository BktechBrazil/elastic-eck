root@eck-lab:~# source ../_assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
-bash: ../_assets/versions.env: No such file or directory
root@eck-lab:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
root@eck-lab:~# kubectl get crd | grep -E 'beats|agents|logstashes'
agents.agent.k8s.elastic.co                            2026-08-07T12:48:58Z
beats.beat.k8s.elastic.co                              2026-08-07T12:48:58Z
logstashes.logstash.k8s.elastic.co                     2026-08-07T12:48:58Z
root@eck-lab:~# kubectl apply -f manifests/filebeat.yaml
error: the path "manifests/filebeat.yaml" does not exist
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/filebeat.yaml
# Filebeat via CRD Beat do ECK — coleta logs de containers em todos os nós (DaemonSet)
# Namespace: elastic. RBAC incluído para o add_kubernetes_metadata enriquecer os eventos.
---
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
kubectl -n elastic get beat filebeat -wlainerstainershboards do Filebeatautomaticamente
serviceaccount/filebeat created
clusterrole.rbac.authorization.k8s.io/filebeat created
clusterrolebinding.rbac.authorization.k8s.io/filebeat created
beat.beat.k8s.elastic.co/filebeat created
NAME       HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat                                   filebeat             1s
filebeat                                   filebeat             1s
filebeat                                   filebeat             1s
filebeat                                   filebeat             1s
filebeat                                   filebeat             1s
filebeat                                   filebeat             1s
filebeat   red                             filebeat   9.4.2     2s
filebeat   red                  1          filebeat   9.4.2     2s
filebeat   green    1           1          filebeat   9.4.2     11s
filebeat   red                  1          filebeat   9.4.2     12s
filebeat   green    1           1          filebeat   9.4.2     30s
^Croot@eck-lab:~kubectl apply -f manifests/filebeat.yamlml
serviceaccount/filebeat unchanged
clusterrole.rbac.authorization.k8s.io/filebeat unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat unchanged
beat.beat.k8s.elastic.co/filebeat unchanged
root@eck-lab:~# kubectl -n elastic get beat filebeat            # aguarde HEALTH green
NAME       HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat   red                  1          filebeat   9.4.2     2m
root@eck-lab:~# kubectl -n elastic get pods -l beat.k8s.elastic.co/name=filebeat
NAME                           READY   STATUS   RESTARTS       AGE
filebeat-beat-filebeat-n9j7q   0/1     Error    2 (115s ago)   2m7s
root@eck-lab:~# mkdir -p manifests
root@eck-lab:~# mkdir -p manifestsyaml
cat << 'EOF' > mkubectl -n elastic get pods -l beat.k8s.elastic.co/name=filebeat
                mkdir -p manifests
cat << 'EOF' > mkubectl -n elastic get pods -l beat.k8s.elastic.co/name=filebeat
                pwd
/root
root@eck-lab:~# mkdir -p manifests
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
kubectl apply -f manifests/filebeat.yamlainerstainers
serviceaccount/filebeat unchanged
clusterrole.rbac.authorization.k8s.io/filebeat unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat unchanged
beat.beat.k8s.elastic.co/filebeat unchanged
root@eck-lab:~# mkdir -p manifests
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
              path: /var/lib/docker/containerstainers
> q
> ^C
root@eck-lab:~# mkdir -p manifests
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
EOF           path: /var/lib/docker/containerstainers
root@eck-lab:~# kubectl apply -f manifests/filebeat.yaml
serviceaccount/filebeat unchanged
clusterrole.rbac.authorization.k8s.io/filebeat unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat unchanged
beat.beat.k8s.elastic.co/filebeat unchanged
root@eck-lab:~# kubectl -n elastic get beat filebeat            # aguarde HEALTH green
NAME       HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat   green    1           1          filebeat   9.4.2     5m21s
root@eck-lab:~# kubectl -n elastic get pods -l beat.k8s.elastic.co/name=filebeat
NAME                           READY   STATUS    RESTARTS       AGE
filebeat-beat-filebeat-n9j7q   1/1     Running   4 (107s ago)   5m33s
root@eck-lab:~# Handling connection for 5601
E0810 13:57:07.458456 2656298 portforward.go:398] "Unhandled Error" err="error copying from local connection to remote stream: writeto tcp4 207.244.255.225:5601->64.49.11.198:58575: read tcp4 207.244.255.225:5601->64.49.11.198:58575: read: connection reset by peer"
Handling connection for 5601
Handling connection for 5601
^C
root@eck-lab:~# curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices/*filebeat*?v" \
> ^C
root@eck-lab:~# curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices/*filebeat*?v"
root@eck-lab:~# kubectl delete -f manifests/filebeat.yaml
serviceaccount "filebeat" deleted
clusterrole.rbac.authorization.k8s.io "filebeat" deleted
clusterrolebinding.rbac.authorization.k8s.io "filebeat" deleted
beat.beat.k8s.elastic.co "filebeat" deleted
root@eck-lab:~# kubectl apply -f manifests/logstash.yaml
error: the path "manifests/logstash.yaml" does not exist
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > mkubectl apply -f manifests/logstash.yaml
                mkdir -p manifests
cat << 'EOF' > mkubectl apply -f manifests/logstash.yaml
                cat << 'EOF' > manifests/filebeat.yaml
apiVersion: v1  mkdir -p manifests
                cat << 'EOF' > manifests/filebeat.yaml
apiVersion: v1  mkdir -p manifests
                cat << 'EOF' > manifests/filebeat.yaml
apiVersion: v1  mkdir -p manifests
                pwd
/root
root@eck-lab:~# mkdir -p manifests
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
EOF           memory: 1536Mi44arem eventos (porta 5044)
root@eck-lab:~# kubectl apply -f manifests/logstash.yaml
logstash.logstash.k8s.elastic.co/lab-logstash created
root@eck-lab:~# kubectl -n elastic get logstash lab-logstash
NAME           HEALTH   AVAILABLE   EXPECTED   AGE   VERSION
lab-logstash   red                  1          7s    9.4.2
root@eck-lab:~# kubectl -n elastic get logstash lab-logstash
NAME           HEALTH   AVAILABLE   EXPECTED   AGE   VERSION
lab-logstash   red                  1          40s   9.4.2
root@eck-lab:~# kubectl -n elastic get svc | grep lab-logstash  # note o service lab-logstash-ls-beats:5044
lab-logstash-ls-api           ClusterIP   None             <none>        9600/TCP   50s
lab-logstash-ls-beats         ClusterIP   10.101.20.95     <none>        5044/TCP   50s
root@eck-lab:~#
root@eck-lab:~#

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
EOF           memory: 1536Mi44arem eventos (porta 5044)_SSL_CERTIFICATE_AUTHORITY}"
root@eck-lab:~# kubectl apply -f manifests/logstash.yaml
logstash.logstash.k8s.elastic.co/lab-logstash configured
root@eck-lab:~# kubectl -n elastic get logstash lab-logstash    # aguarde disponível
NAME           HEALTH   AVAILABLE   EXPECTED   AGE     VERSION
lab-logstash   green    1           1          3m36s   9.4.2
root@eck-lab:~# kubectl -n elastic get svc | grep lab-logstash  # note o service lab-logstash-ls-beats:5044
lab-logstash-ls-api           ClusterIP   None             <none>        9600/TCP   3m45s
lab-logstash-ls-beats         ClusterIP   10.101.20.95     <none>        5044/TCP   3m45s
root@eck-lab:~# cat << 'EOF' > manifests/logstash.yaml
# Logstash via Cmkdir -p manifestsbeats -> filtro -> elasticsearch
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
EOF           memory: 1536Mi44arem eventos (porta 5044)
root@eck-lab:~# cat << 'EOF' > manifests/logstash.yaml
# Logstash via CRD Logstash do ECK — pipeline central beats -> filtro -> elasticsearch
# O operator injmkdir -p manifestsdo elasticsearchRefs (clusterName: lab-es).
                cat << 'EOF' > manifests/logstash.yaml
# Logstash via Cmkdir -p manifestsbeats -> filtro -> elasticsearch
                cat << 'EOF' > manifests/logstash.yaml
# Logstash via Ckubectl apply -f ECK — pipeline central beats -> filtro -> elasticsearch
root@eck-lab:~# pwd
/root
root@eck-lab:~# kubectl apply -f manifests/filebeat-para-logstash.yaml
error: the path "manifests/filebeat-para-logstash.yaml" does not exist
root@eck-lab:~# mkdir manifests/filebeat-para-logstash.yaml
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/filebeat-para-logstash.yaml
# Variante do Filebeat que envia para o LOGSTASH (não direto ao ES).
# Demonstra o fluxo Beats -> Logstash -> Elasticsearch.
# O Service criado pelo CRD Logstash chama-se <nome>-ls-<service> => lab-logstash-ls-beats:5044
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat-ls
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat-ls
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat-ls
subjects:
  - kind: ServiceAccount
    name: filebeat-ls
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat-ls
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat-ls
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  # SEM elasticsearchRef: a saída vai para o Logstash, definida no config abaixo.
  config:
    filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
    output.elasticsearch.enabled: false
    output.logstash:
      hosts: ["lab-logstash-ls-beats:5044"]
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat-ls
        automountServiceAccountToken: true
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
        securityContext:
          runAsUser: 0
EOF           path: /var/log/podsainerssainers
-bash: manifests/filebeat-para-logstash.yaml: Is a directory
root@eck-lab:~# kubectl apply -f manifests/filebeat-para-logstash.yaml
error: error reading [manifests/filebeat-para-logstash.yaml]: recognized file extensions are [.json .yaml .yml]
root@eck-lab:~# ls -la manifests/
total 40
drwxr-xr-x 3 root root 4096 Aug 10 14:29 .
drwx------ 9 root root 4096 Aug  7 16:43 ..
-rw-r--r-- 1 root root  833 Aug  7 14:51 elasticsearch-quickstart.yaml
-rw-r--r-- 1 root root  815 Aug  7 15:23 elasticsearch.yaml
drwxr-xr-x 2 root root 4096 Aug 10 14:29 filebeat-para-logstash.yaml
-rw-r--r-- 1 root root 2350 Aug 10 13:56 filebeat.yaml
-rw-r--r-- 1 root root  359 Aug  7 14:56 kibana-quickstart.yaml
-rw-r--r-- 1 root root  351 Aug  7 15:23 kibana.yaml
-rw-r--r-- 1 root root 1597 Aug 10 14:24 logstash.yaml
-rw-r--r-- 1 root root  819 Aug  7 19:43 topo-es.yaml
root@eck-lab:~# ls -ls manifests/filebeat-para-logstash.yaml/
total 0
root@eck-lab:~# rm manifests/filebeat-para-logstash.yaml/
rm: cannot remove 'manifests/filebeat-para-logstash.yaml/': Is a directory
root@eck-lab:~# rmdir manifests/filebeat-para-logstash.yaml/
root@eck-lab:~# cat << 'EOF' > manifests/filebeat-para-logstash.yaml
# Variante do Filebeat que envia para o LOGSTASH (não direto ao ES).
# Demonstra o fluxo Beats -> Logstash -> Elasticsearch.
# O Service criado pelo CRD Logstash chama-se <nome>-ls-<service> => lab-logstash-ls-beats:5044
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat-ls
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat-ls
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat-ls
subjects:
  - kind: ServiceAccount
    name: filebeat-ls
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat-ls
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat-ls
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  # SEM elasticsearchRef: a saída vai para o Logstash, definida no config abaixo.
  config:
    filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
    output.elasticsearch.enabled: false
    output.logstash:
      hosts: ["lab-logstash-ls-beats:5044"]
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat-ls
        automountServiceAccountToken: true
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
        securityContext:
          runAsUser: 0
        containers:
EOF           path: /var/log/podsainerssainers
root@eck-lab:~# cat << 'EOF' > manifests/filebeat-para-logstash.yaml
# Variante do Fi
                pwd
/root
root@eck-lab:~# kubectl apply -f manifests/filebeat-para-logstash.yaml
serviceaccount/filebeat-ls created
clusterrole.rbac.authorization.k8s.io/filebeat-ls created
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls created
beat.beat.k8s.elastic.co/filebeat-ls created
root@eck-lab:~# kubectl -n elastic get beat filebeat-ls
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   red                  1          filebeat   9.4.2     6s
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/filebeat-para-logstash.yaml
# Variante do Filebeat que envia para o LOGSTASH (não direto ao ES).
# Demonstra o fluxo Beats -> Logstash -> Elasticsearch.
# O Service criado pelo CRD Logstash chama-se <nome>-ls-<service> => lab-logstash-ls-beats:5044
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat-ls
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat-ls
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat-ls
subjects:
  - kind: ServiceAccount
    name: filebeat-ls
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat-ls
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat-ls
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  # SEM elasticsearchRef: a saída vai para o Logstash, definida no config abaixo.
  config:
    filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
    output.elasticsearch.enabled: false
    output.logstash:
      hosts: ["lab-logstash-ls-beats:5044"]
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat-ls
        automountServiceAccountToken: true
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
        securityContext:
          runAsUser: 0
EOF           path: /var/log/podsainerssainers
root@eck-lab:~# cat << 'EOF' > manifests/filebeat-para-logstash.yaml
# Variante do Fimkdir -p manifests
                kubectl apply -f manifests/filebeat-para-logstash.yaml
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls unchanged
root@eck-lab:~# cat << 'EOF' > manifests/filebeat-para-logstash.yaml
# Variante do Fimkdir -p manifests
                kubectl -n elastic get beat filebeat-ls
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   red                  1          filebeat   9.4.2     61s
root@eck-lab:~#
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/filebeat-para-logstash.yaml
# Variante do Filebeat que envia para o LOGSTASH (não direto ao ES).
# Demonstra o fluxo Beats -> Logstash -> Elasticsearch.
# O Service criado pelo CRD Logstash chama-se <nome>-ls-<service> => lab-logstash-ls-beats:5044
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat-ls
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat-ls
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat-ls
subjects:
  - kind: ServiceAccount
    name: filebeat-ls
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat-ls
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat-ls
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  # SEM elasticsearchRef: a saída vai para o Logstash, definida no config abaixo.
  config:
    filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
    output.elasticsearch.enabled: false
    output.logstash:
      hosts: ["lab-logstash-ls-beats:5044"]
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat-ls
        automountServiceAccountToken: true
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
        securityContext:
          runAsUser: 0
EOF           path: /var/log/podsainerssainers
root@eck-lab:~# kubectl apply -f manifests/filebeat-para-logstash.yaml
kubectl -n elastic get beat filebeat-ls -w
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls unchanged
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   red                  1          filebeat   9.4.2     117s
^Croot@eck-lab:~#
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/filebeat-para-logstash.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat-ls
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat-ls
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat-ls
subjects:
  - kind: ServiceAccount
    name: filebeat-ls
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat-ls
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat-ls
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  config:
    filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
    output.elasticsearch.enabled: false
    output.logstash:
      hosts: ["lab-logstash-ls-beats:5044"]
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat-ls
        automountServiceAccountToken: true
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
        securityContext:
          runAsUser: 0
        containers:
          - name: filebeat
            resources:
              requests:
                memory: 200Mi
kubectl apply -f manifests/filebeat-para-logstash.yaml
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls unchanged
root@eck-lab:~# kubectl apply -f manifests/filebeat-para-logstash.yaml
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls unchanged
root@eck-lab:~# Handling connection for 5601
^C
root@eck-lab:~# kubectl -n elastic get logstash lab-logstash
kubectl -n elastic get beat filebeat-ls -w
NAME           HEALTH   AVAILABLE   EXPECTED   AGE   VERSION
lab-logstash   green    1           1          16m   9.4.2
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   red                  1          filebeat   9.4.2     5m6s
^Croot@eck-lab:~# cat << 'EOF' > manifests/filebeat-para-logstash.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat-ls
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat-ls
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat-ls
subjects:
  - kind: ServiceAccount
    name: filebeat-ls
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat-ls
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat-ls
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  config:
    filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
    output.elasticsearch.enabled: false
    output.logstash:
      hosts: ["lab-logstash-ls-beats:5044"]
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat-ls
        automountServiceAccountToken: true
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
kubectl -n elastic get beat filebeat-ls -wogstash.yaml
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls unchanged
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   red                  1          filebeat   9.4.2     5m54s
^Croot@eck-lab:~# kubectl -n elastic get beat filebeat-ls -w
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   red                  1          filebeat   9.4.2     7m37s
^Croot@eck-lab:~kubectl -n elastic get pods -l beat.k8s.elastic.co/name=filebeat-lsls
kubectl -n elastic logs -l beat.k8s.elastic.co/name=filebeat-ls --tail=20
NAME                              READY   STATUS             RESTARTS        AGE
filebeat-ls-beat-filebeat-2bspj   0/1     CrashLoopBackOff   6 (2m17s ago)   8m3s
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.006Z","log.logger":"crawler","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/beater.(*crawler).Start","file.name":"beater/crawler.go","file.line":76},"message":"Loading Inputs: 1","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.007Z","log.logger":"crawler","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/beater.(*crawler).Stop","file.name":"beater/crawler.go","file.line":155},"message":"Stopping Crawler","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.007Z","log.logger":"crawler","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/beater.(*crawler).Stop","file.name":"beater/crawler.go","file.line":165},"message":"Stopping 0 inputs","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.007Z","log.logger":"crawler","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/beater.(*crawler).Stop","file.name":"beater/crawler.go","file.line":185},"message":"Crawler stopped","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.007Z","log.logger":"registrar","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/registrar.(*Registrar).Stop","file.name":"registrar/registrar.go","file.line":126},"message":"Stopping Registrar","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.007Z","log.logger":"registrar","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/registrar.(*Registrar).Run","file.name":"registrar/registrar.go","file.line":162},"message":"Ending Registrar","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.007Z","log.logger":"registrar","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/registrar.(*Registrar).Stop","file.name":"registrar/registrar.go","file.line":131},"message":"Registrar stopped","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.007Z","log.origin":{"function":"github.com/elastic/beats/v7/filebeat/beater.(*Filebeat).Stop","file.name":"beater/filebeat.go","file.line":561},"message":"Stopping filebeat","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.011Z","log.logger":"monitoring","log.origin":{"function":"github.com/elastic/beats/v7/libbeat/monitoring/report/log.(*Reporter).logTotals","file.name":"log/log.go","file.line":195},"message":"Total metrics","service.name":"filebeat","monitoring":{"metrics":{"beat":{"cgroup":{"cpu":{"id":"/","stats":{"periods":0,"throttled":{"ns":0,"periods":0}}},"memory":{"id":"/","mem":{"usage":{"bytes":41791488}}}},"cpu":{"system":{"ticks":80,"time":{"ms":80}},"total":{"ticks":190,"time":{"ms":190},"value":190},"user":{"ticks":110,"time":{"ms":110}}},"handles":{"limit":{"hard":524288,"soft":524287},"open":8},"info":{"ephemeral_id":"709500a3-de11-42b1-ade5-7ebdfd4a0f2c","name":"filebeat","uptime":{"ms":67},"version":"9.4.2"},"memstats":{"gc_next":17016650,"memory_alloc":13256824,"memory_sys":28399880,"memory_total":25979464,"rss":124784640},"runtime":{"goroutines":5}},"filebeat":{"events":{"active":0,"added":0,"done":0},"harvester":{"closed":0,"open_files":0,"running":0,"skipped":0,"started":0},"input":{"log":{"files":{"renamed":0,"truncated":0}}}},"libbeat":{"config":{"module":{"running":0,"starts":0,"stops":0},"reloads":0,"scans":0},"output":{"batches":{"split":0},"events":{"acked":0,"active":0,"batches":0,"dead_letter":0,"dropped":0,"duplicates":0,"failed":0,"failure_store":0,"toomany":0,"total":0},"read":{"bytes":0,"errors":0},"type":"logstash","write":{"bytes":0,"errors":0,"latency":{"histogram":{"count":0,"max":0,"mean":0,"median":0,"min":0,"p75":0,"p95":0,"p99":0,"p999":0,"stddev":0}},"latency_delta":{"histogram":{"count":0,"max":0,"median":0,"min":0,"p99":0}}}}},"registrar":{"states":{"cleanup":0,"current":0,"update":0},"writes":{"fail":0,"success":0,"total":0}},"system":{"cpu":{"cores":8},"load":{"1":0.39,"15":1.06,"5":0.82,"norm":{"1":0.0488,"15":0.1325,"5":0.1025}}}},"info":{"beat":"filebeat","binary_arch":"amd64","build_commit":"e98b93df5a916738f04a338ea2ddcf53ebd0bc0b","build_time":"2026-05-22T19:43:08.000Z","elastic_licensed":true,"ephemeral_id":"709500a3-de11-42b1-ade5-7ebdfd4a0f2c","gid":"0","hostname":"eck-lab","name":"eck-lab","uid":"0","username":"root","uuid":"1e823b00-a5ea-4d04-942b-ab4fc0776045","version":"9.4.2"},"state":{"beat":{"name":"eck-lab"},"host":{"architecture":"x86_64","containerized":false,"hostname":"eck-lab","id":"82772ff23ad708813df7da6000e73142","os":{"codename":"Plow","family":"redhat","kernel":"5.15.0-186-generic","name":"Red Hat Enterprise Linux","platform":"rhel","version":"9.8 (Plow)"}},"input":{"count":0},"management":{"enabled":false},"module":{"count":0},"output":{"batch_size":2048,"clients":1,"name":"logstash"},"outputs":{"elasticsearch":{"cluster_uuid":""}},"queue":{"name":"mem"},"service":{"id":"1e823b00-a5ea-4d04-942b-ab4fc0776045","name":"filebeat","version":"9.4.2"}},"ecs.version":"1.6.0"}}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.012Z","log.logger":"monitoring","log.origin":{"function":"github.com/elastic/beats/v7/libbeat/monitoring/report/log.(*Reporter).logTotals","file.name":"log/log.go","file.line":196},"message":"Uptime: 7.776077ms","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.012Z","log.logger":"monitoring","log.origin":{"function":"github.com/elastic/beats/v7/libbeat/monitoring/report/log.(*Reporter).snapshotLoop","file.name":"log/log.go","file.line":163},"message":"Stopping metrics logging.","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"info","@timestamp":"2026-08-10T12:38:16.012Z","log.origin":{"function":"github.com/elastic/beats/v7/libbeat/cmd/instance.(*Beat).launch","file.name":"instance/beat.go","file.line":548},"message":"filebeat stopped.","service.name":"filebeat","ecs.version":"1.6.0"}
{"log.level":"error","@timestamp":"2026-08-10T12:38:16.012Z","log.origin":{"function":"github.com/elastic/beats/v7/libbeat/cmd/instance.handleError","file.name":"instance/beat.go","file.line":1360},"message":"Exiting: Failed to start crawler: starting input failed: error while initializing input: Found container input configuration: Container input is deprecated. Use Filestream input with its container parser instead. https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-input-filestream.html#_container\n{\n  \"paths\": [\n    \"/var/log/containers/*.log\"\n  ],\n  \"type\": \"container\"\n}","service.name":"filebeat","ecs.version":"1.6.0"}
Exiting: Failed to start crawler: starting input failed: error while initializing input: Found container input configuration: Container input is deprecated. Use Filestream input with its container parser instead. https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-input-filestream.html#_container
{
  "paths": [
    "/var/log/containers/*.log"
  ],
  "type": "container"
}
root@eck-lab:~#
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/filebeat-para-logstash.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: filebeat-ls
  namespace: elastic
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: filebeat-ls
rules:
  - apiGroups: [""]
    resources: ["namespaces", "pods", "nodes"]
    verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: filebeat-ls
subjects:
  - kind: ServiceAccount
    name: filebeat-ls
    namespace: elastic
roleRef:
  kind: ClusterRole
  name: filebeat-ls
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: beat.k8s.elastic.co/v1beta1
kind: Beat
metadata:
  name: filebeat-ls
  namespace: elastic
spec:
  type: filebeat
  version: 9.4.2
  config:
    filebeat.inputs:
      - type: filestream
        id: container-logs
        paths:
          - /var/log/containers/*.log
        parsers:
          - container: {}
    output.elasticsearch.enabled: false
    output.logstash:
      hosts: ["lab-logstash-ls-beats:5044"]
  daemonSet:
    podTemplate:
      spec:
        serviceAccountName: filebeat-ls
        automountServiceAccountToken: true
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
        securityContext:
          runAsUser: 0
        containers:
          - name: filebeat
kubectl -n elastic get beat filebeat-ls -logstash.yaml
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls configured
error: name cannot be provided when a selector is specified
root@eck-lab:~# echo "YXBpVmVyc2lvbjogdjEKa2luZDogU2VydmljZUFjY291bnQKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKICBuYW1lc3BhY2U6IGVsYXN0aWMKLS0tCmFwaVZlcnNpb246IHJiYWMuYXV0aG9yaXphdGlvbi5rOHMuaW8vdjEKa2luZDogQ2x1c3RlclJvbGUKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKcnVsZXM6CiAgLSBhcGlHcm91cHM6IFsiIl0KICAgIHJlc291cmNlczogWyJuYW1lc3BhY2VzIiwgInBvZHMiLCAibm9kZXMiXQogICAgdmVyYnM6IFsiZ2V0IiwgIndhdGNoIiwgImxpc3QiXQotLS0KYXBpVmVyc2lvbjogcmJhYy5hdXRob3JpemF0aW9uLms4cy5pby92MQpraW5kOiBDbHVzdGVyUm9sZUJpbmRpbmcKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKc3ViamVjdHM6CiAgLSBraW5kOiBTZXJ2aWNlQWNjb3VudAogICAgbmFtZTogZmlsZWJlYXQtbHMKICAgIG5hbWVzcGFjZTogZWxhc3RpYwpyb2xlUmVmOgogIGtpbmQ6IENsdXN0ZXJSb2xlCiAgbmFtZTogZmlsZWJlYXQtbHMKICBhcGlHcm91cDogcmJhYy5hdXRob3JpemF0aW9uLms4cy5pbwotLS0KYXBpVmVyc2lvbjogYmVhdC5rOHMuZWxhc3RpYy5jby92MWJldGExCmtpbmQ6IEJlYXQKbWV0YWRhdGE6CiAgbmFtZTogZmlsZWJlYXQtbHMKICBuYW1lc3BhY2U6IGVsYXN0aWMKc3BlYzoKICB0eXBlOiBmaWxlYmVhdAogIHZlcnNpb246IDkuNC4yCiAgY29uZmlnOgogICAgZmlsZWJlYXQuaW5wdXRzOgogICAgICAtIHR5cGU6IGZpbGVzdHJlYW0KICAgICAgICBpZDogY29udGFpbmVyLWxvZ3MKICAgICAgICBwYXRoczoKICAgICAgICAgIC0gL3Zhci9sb2cvY29udGFpbmVycy8qLmxvZwogICAgICAgIHBhcnNlcnM6CiAgICAgICAgICAtIGNvbnRhaW5lcjoge30KICAgIG91dHB1dC5lbGFzdGljc2VhcmNoLmVuYWJsZWQ6IGZhbHNlCiAgICBvdXRwdXQubG9nc3Rhc2g6CiAgICAgIGhvc3RzOiBbImxhYi1sb2dzdGFzaC1scy1iZWF0czo1MDQ0Il0KICBkYWVtb25TZXQ6CiAgICBwb2RUZW1wbGF0ZToKICAgICAgc3BlYzoKICAgICAgICBzZXJ2aWNlQWNjb3VudE5hbWU6IGZpbGViZWF0LWxzCiAgICAgICAgYXV0b21vdW50U2VydmljZUFjY291bnRUb2tlbjogdHJ1ZQogICAgICAgIGhvc3ROZXR3b3JrOiB0cnVlCiAgICAgICAgZG5zUG9saWN5OiBDbHVzdGVyRmlyc3RXaXRoSG9zdE5ldAogICAgICAgIHNlY3VyaXR5Q29udGV4dDoKICAgICAgICAgIHJ1bkFzVXNlcjogMAogICAgICAgIGNvbnRhaW5lcnM6CiAgICAgICAgICAtIG5hbWU6IGZpbGViZWF0CiAgICAgICAgICAgIHJlc291cmNlczoKICAgICAgICAgICAgICByZXF1ZXN0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogMjAwTWkKICAgICAgICAgICAgICAgIGNwdTogMTAwbQogICAgICAgICAgICAgIGxpbWl0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogMzAwTWkKICAgICAgICAgICAgdm9sdW1lTW91bnRzOgogICAgICAgICAgICAgIC0gbmFtZTogdmFybG9nY29udGFpbmVycwogICAgICAgICAgICAgICAgbW91bnRQYXRoOiAvdmFyL2xvZy9jb250YWluZXJzCiAgICAgICAgICAgICAgLSBuYW1lOiB2YXJsb2dwb2RzCiAgICAgICAgICAgICAgICBtb3VudFBhdGg6IC92YXIvbG9nL3BvZHMKICAgICAgICB2b2x1bWVzOgogICAgICAgICAgLSBuYW1lOiB2YXJsb2djb250YWluZXJzCiAgICAgICAgICAgIGhvc3RQYXRoOgogICAgICAgICAgICAgIHBhdGg6IC92YXIvbG9nL2NvbnRhaW5lcnMKICAgICAgICAgIC0gbmFtZTogdmFybG9ncG9kcwogICAgICAgICAgICBob3N0UGF0aDoKICAgICAgICAgICAgICBwYXRoOiAvdmFyL2xvZy9wb2RzCg==" | base64 -d > manifests/filebeat-para-logstash.yaml
kubectl apply -f manifests/filebeat-para-logstash.yaml
kubectl -n elastic get beat filebeat-ls -w
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls unchanged
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   green    1           1          filebeat   9.4.2     10m
^Croot@eck-lab:~kubectl -n elastic get beat filebeat-lsls
NAME          HEALTH   AVAILABLE   EXPECTED   TYPE       VERSION   AGE
filebeat-ls   green    1           1          filebeat   9.4.2     10m
root@eck-lab:~# kubectl apply -f manifests/filebeat-para-logstash.yaml
serviceaccount/filebeat-ls unchanged
clusterrole.rbac.authorization.k8s.io/filebeat-ls unchanged
clusterrolebinding.rbac.authorization.k8s.io/filebeat-ls unchanged
beat.beat.k8s.elastic.co/filebeat-ls unchanged
root@eck-lab:~# curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices/logstash-lab-*?v"
root@eck-lab:~# kubectl delete -f manifests/filebeat-para-logstash.yaml
serviceaccount "filebeat-ls" deleted
clusterrole.rbac.authorization.k8s.io "filebeat-ls" deleted
clusterrolebinding.rbac.authorization.k8s.io "filebeat-ls" deleted
beat.beat.k8s.elastic.co "filebeat-ls" deleted
root@eck-lab:~# kubectl delete -f manifests/logstash.yaml
logstash.logstash.k8s.elastic.co "lab-logstash" deleted
root@eck-lab:~#
root@eck-lab:~# Handling connection for 5601
Handling connection for 5601
^C
root@eck-lab:~# mkdir -p manifests
echo "IyBFbGFzdGljIEFnZW50IFNUQU5EQUxPTkUgdmlhIENSRCBBZ2VudCBkbyBFQ0sg4oCUIGNvbGV0YSBtw6l0cmljYXMgZG8gc2lzdGVtYSAoRGFlbW9uU2V0KS4KIyBBIGNvbmZpZ3VyYcOnw6NvIGRlIGNvbGV0YSB2aXZlIGVtIHNwZWMuY29uZmlnIChzZW0gRmxlZXQvVUkpLiBPIG9wZXJhdG9yIGNyaWEgYSBzYcOtZGEKIyAiZGVmYXVsdCIgYXV0b21hdGljYW1lbnRlIGEgcGFydGlyIGRvIGVsYXN0aWNzZWFyY2hSZWZzLgotLS0KYXBpVmVyc2lvbjogdjEKa2luZDogU2VydmljZUFjY291bnQKbWV0YWRhdGE6CiAgbmFtZTogZWxhc3RpYy1hZ2VudAogIG5hbWVzcGFjZTogZWxhc3RpYwotLS0KYXBpVmVyc2lvbjogcmJhYy5hdXRob3JpemF0aW9uLms4cy5pby92MQpraW5kOiBDbHVzdGVyUm9sZQptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CnJ1bGVzOgogIC0gYXBpR3JvdXBzOiBbIiJdCiAgICByZXNvdXJjZXM6IFsibm9kZXMiLCAibmFtZXNwYWNlcyIsICJwb2RzIiwgImV2ZW50cyIsICJzZXJ2aWNlcyJdCiAgICB2ZXJiczogWyJnZXQiLCAibGlzdCIsICJ3YXRjaCJdCiAgLSBhcGlHcm91cHM6IFsiYXBwcyJdCiAgICByZXNvdXJjZXM6IFsicmVwbGljYXNldHMiLCAiZGVwbG95bWVudHMiLCAiZGFlbW9uc2V0cyIsICJzdGF0ZWZ1bHNldHMiXQogICAgdmVyYnM6IFsiZ2V0IiwgImxpc3QiLCAid2F0Y2giXQogIC0gbm9uUmVzb3VyY2VVUkxzOiBbIi9tZXRyaWNzIl0KICAgIHZlcmJzOiBbImdldCJdCi0tLQphcGlWZXJzaW9uOiByYmFjLmF1dGhvcml6YXRpb24uazhzLmlvL3YxCmtpbmQ6IENsdXN0ZXJSb2xlQmluZGluZwptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CnN1YmplY3RzOgogIC0ga2luZDogU2VydmljZUFjY291bnQKICAgIG5hbWU6IGVsYXN0aWMtYWdlbnQKICAgIG5hbWVzcGFjZTogZWxhc3RpYwpyb2xlUmVmOgogIGtpbmQ6IENsdXN0ZXJSb2xlCiAgbmFtZTogZWxhc3RpYy1hZ2VudAogIGFwaUdyb3VwOiByYmFjLmF1dGhvcml6YXRpb24uazhzLmlvCi0tLQphcGlWZXJzaW9uOiBhZ2VudC5rOHMuZWxhc3RpYy5jby92MWFscGhhMQpraW5kOiBBZ2VudAptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CiAgbmFtZXNwYWNlOiBlbGFzdGljCnNwZWM6CiAgdmVyc2lvbjogOS40LjIKICBlbGFzdGljc2VhcmNoUmVmczoKICAgIC0gbmFtZTogbGFiLWVzICAgICAgICAgICMgY3JpYSBhIHNhw61kYSAiZGVmYXVsdCIgY29tIGhvc3QvY3JlZGVuY2lhaXMvQ0EgYXV0b21hdGljYW1lbnRlCiAgZGFlbW9uU2V0OgogICAgcG9kVGVtcGxhdGU6CiAgICAgIHNwZWM6CiAgICAgICAgc2VydmljZUFjY291bnROYW1lOiBlbGFzdGljLWFnZW50CiAgICAgICAgYXV0b21vdW50U2VydmljZUFjY291bnRUb2tlbjogdHJ1ZQogICAgICAgIHNlY3VyaXR5Q29udGV4dDoKICAgICAgICAgIHJ1bkFzVXNlcjogMAogICAgICAgIGNvbnRhaW5lcnM6CiAgICAgICAgICAtIG5hbWU6IGFnZW50CiAgICAgICAgICAgIHJlc291cmNlczoKICAgICAgICAgICAgICByZXF1ZXN0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogMzUwTWkKICAgICAgICAgICAgICAgIGNwdTogMTAwbQogICAgICAgICAgICAgIGxpbWl0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogNTAwTWkKICBjb25maWc6CiAgICBpZDogbGFiLWFnZW50CiAgICBhZ2VudDoKICAgICAgbW9uaXRvcmluZzoKICAgICAgICBlbmFibGVkOiB0cnVlCiAgICAgICAgdXNlX291dHB1dDogZGVmYXVsdAogICAgICAgIGxvZ3M6IHRydWUKICAgICAgICBtZXRyaWNzOiB0cnVlCiAgICBpbnB1dHM6CiAgICAgIC0gaWQ6IHN5c3RlbS1tZXRyaWNzCiAgICAgICAgdHlwZTogc3lzdGVtL21ldHJpY3MKICAgICAgICB1c2Vfb3V0cHV0OiBkZWZhdWx0CiAgICAgICAgZGF0YV9zdHJlYW06CiAgICAgICAgICBuYW1lc3BhY2U6IGRlZmF1bHQKICAgICAgICBzdHJlYW1zOgogICAgICAgICAgLSBpZDogY3B1CiAgICAgICAgICAgIGRhdGFfc3RyZWFtOiB7IGRhdGFzZXQ6IHN5c3RlbS5jcHUsIHR5cGU6IG1ldHJpY3MgfQogICAgICAgICAgICBtZXRyaWNzZXRzOiBbY3B1XQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogbWVtb3J5CiAgICAgICAgICAgIGRhdGFfc3RyZWFtOiB7IGRhdGFzZXQ6IHN5c3RlbS5tZW1vcnksIHR5cGU6IG1ldHJpY3MgfQogICAgICAgICAgICBtZXRyaWNzZXRzOiBbbWVtb3J5XQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogbmV0d29yawogICAgICAgICAgICBkYXRhX3N0cmVhbTogeyBkYXRhc2V0OiBzeXN0ZW0ubmV0d29yaywgdHlwZTogbWV0cmljcyB9CiAgICAgICAgICAgIG1ldHJpY3NldHM6IFtuZXR3b3JrXQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogZmlsZXN5c3RlbQogICAgICAgICAgICBkYXRhX3N0cmVhbTogeyBkYXRhc2V0OiBzeXN0ZW0uZmlsZXN5c3RlbSwgdHlwZTogbWV0cmljcyB9CiAgICAgICAgICAgIG1ldHJpY3NldHM6IFtmaWxlc3lzdGVtXQogICAgICAgICAgICBwZXJpb2Q6IDFtCg==" | base64 -d > manifests/elastic-agent-standalone.yaml

kubectl apply -f manifests/elastic-agent-standalone.yaml
kubectl -n elastic get agent elastic-agent -w
serviceaccount/elastic-agent created
clusterrole.rbac.authorization.k8s.io/elastic-agent created
clusterrolebinding.rbac.authorization.k8s.io/elastic-agent created
agent.agent.k8s.elastic.co/elastic-agent created
NAME            HEALTH   AVAILABLE   EXPECTED   VERSION   AGE
elastic-agent                                             0s
elastic-agent                                             0s
elastic-agent                                             0s
elastic-agent   red                  1                    0s
elastic-agent   red                  1          9.4.2     0s
root@eck-lab:~# mkdir -p manifeststs
echo "IyBFbGFzdGljIEFnZW50IFNUQU5EQUxPTkUgdmlhIENSRCBBZ2VudCBkbyBFQ0sg4oCUIGNvbGV0YSBtw6l0cmljYXMgZG8gc2lzdGVtYSAoRGFlbW9uU2V0KS4KIyBBIGNvbmZpZ3VyYcOnw6NvIGRlIGNvbGV0YSB2aXZlIGVtIHNwZWMuY29uZmlnIChzZW0gRmxlZXQvVUkpLiBPIG9wZXJhdG9yIGNyaWEgYSBzYcOtZGEKIyAiZGVmYXVsdCIgYXV0b21hdGljYW1lbnRlIGEgcGFydGlyIGRvIGVsYXN0aWNzZWFyY2hSZWZzLgotLS0KYXBpVmVyc2lvbjogdjEKa2luZDogU2VydmljZUFjY291bnQKbWV0YWRhdGE6CiAgbmFtZTogZWxhc3RpYy1hZ2VudAogIG5hbWVzcGFjZTogZWxhc3RpYwotLS0KYXBpVmVyc2lvbjogcmJhYy5hdXRob3JpemF0aW9uLms4cy5pby92MQpraW5kOiBDbHVzdGVyUm9sZQptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CnJ1bGVzOgogIC0gYXBpR3JvdXBzOiBbIiJdCiAgICByZXNvdXJjZXM6IFsibm9kZXMiLCAibmFtZXNwYWNlcyIsICJwb2RzIiwgImV2ZW50cyIsICJzZXJ2aWNlcyJdCiAgICB2ZXJiczogWyJnZXQiLCAibGlzdCIsICJ3YXRjaCJdCiAgLSBhcGlHcm91cHM6IFsiYXBwcyJdCiAgICByZXNvdXJjZXM6IFsicmVwbGljYXNldHMiLCAiZGVwbG95bWVudHMiLCAiZGFlbW9uc2V0cyIsICJzdGF0ZWZ1bHNldHMiXQogICAgdmVyYnM6IFsiZ2V0IiwgImxpc3QiLCAid2F0Y2giXQogIC0gbm9uUmVzb3VyY2VVUkxzOiBbIi9tZXRyaWNzIl0KICAgIHZlcmJzOiBbImdldCJdCi0tLQphcGlWZXJzaW9uOiByYmFjLmF1dGhvcml6YXRpb24uazhzLmlvL3YxCmtpbmQ6IENsdXN0ZXJSb2xlQmluZGluZwptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CnN1YmplY3RzOgogIC0ga2luZDogU2VydmljZUFjY291bnQKICAgIG5hbWU6IGVsYXN0aWMtYWdlbnQKICAgIG5hbWVzcGFjZTogZWxhc3RpYwpyb2xlUmVmOgogIGtpbmQ6IENsdXN0ZXJSb2xlCiAgbmFtZTogZWxhc3RpYy1hZ2VudAogIGFwaUdyb3VwOiByYmFjLmF1dGhvcml6YXRpb24uazhzLmlvCi0tLQphcGlWZXJzaW9uOiBhZ2VudC5rOHMuZWxhc3RpYy5jby92MWFscGhhMQpraW5kOiBBZ2VudAptZXRhZGF0YToKICBuYW1lOiBlbGFzdGljLWFnZW50CiAgbmFtZXNwYWNlOiBlbGFzdGljCnNwZWM6CiAgdmVyc2lvbjogOS40LjIKICBlbGFzdGljc2VhcmNoUmVmczoKICAgIC0gbmFtZTogbGFiLWVzICAgICAgICAgICMgY3JpYSBhIHNhw61kYSAiZGVmYXVsdCIgY29tIGhvc3QvY3JlZGVuY2lhaXMvQ0EgYXV0b21hdGljYW1lbnRlCiAgZGFlbW9uU2V0OgogICAgcG9kVGVtcGxhdGU6CiAgICAgIHNwZWM6CiAgICAgICAgc2VydmljZUFjY291bnROYW1lOiBlbGFzdGljLWFnZW50CiAgICAgICAgYXV0b21vdW50U2VydmljZUFjY291bnRUb2tlbjogdHJ1ZQogICAgICAgIHNlY3VyaXR5Q29udGV4dDoKICAgICAgICAgIHJ1bkFzVXNlcjogMAogICAgICAgIGNvbnRhaW5lcnM6CiAgICAgICAgICAtIG5hbWU6IGFnZW50CiAgICAgICAgICAgIHJlc291cmNlczoKICAgICAgICAgICAgICByZXF1ZXN0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogMzUwTWkKICAgICAgICAgICAgICAgIGNwdTogMTAwbQogICAgICAgICAgICAgIGxpbWl0czoKICAgICAgICAgICAgICAgIG1lbW9yeTogNTAwTWkKICBjb25maWc6CiAgICBpZDogbGFiLWFnZW50CiAgICBhZ2VudDoKICAgICAgbW9uaXRvcmluZzoKICAgICAgICBlbmFibGVkOiB0cnVlCiAgICAgICAgdXNlX291dHB1dDogZGVmYXVsdAogICAgICAgIGxvZ3M6IHRydWUKICAgICAgICBtZXRyaWNzOiB0cnVlCiAgICBpbnB1dHM6CiAgICAgIC0gaWQ6IHN5c3RlbS1tZXRyaWNzCiAgICAgICAgdHlwZTogc3lzdGVtL21ldHJpY3MKICAgICAgICB1c2Vfb3V0cHV0OiBkZWZhdWx0CiAgICAgICAgZGF0YV9zdHJlYW06CiAgICAgICAgICBuYW1lc3BhY2U6IGRlZmF1bHQKICAgICAgICBzdHJlYW1zOgogICAgICAgICAgLSBpZDogY3B1CiAgICAgICAgICAgIGRhdGFfc3RyZWFtOiB7IGRhdGFzZXQ6IHN5c3RlbS5jcHUsIHR5cGU6IG1ldHJpY3MgfQogICAgICAgICAgICBtZXRyaWNzZXRzOiBbY3B1XQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogbWVtb3J5CiAgICAgICAgICAgIGRhdGFfc3RyZWFtOiB7IGRhdGFzZXQ6IHN5c3RlbS5tZW1vcnksIHR5cGU6IG1ldHJpY3MgfQogICAgICAgICAgICBtZXRyaWNzZXRzOiBbbWVtb3J5XQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogbmV0d29yawogICAgICAgICAgICBkYXRhX3N0cmVhbTogeyBkYXRhc2V0OiBzeXN0ZW0ubmV0d29yaywgdHlwZTogbWV0cmljcyB9CiAgICAgICAgICAgIG1ldHJpY3NldHM6IFtuZXR3b3JrXQogICAgICAgICAgICBwZXJpb2Q6IDEwcwogICAgICAgICAgLSBpZDogZmlsZXN5c3RlbQogICAgICAgICAgICBkYXRhX3N0cmVhbTogeyBkYXRhc2V0OiBzeXN0ZW0uZmlsZXN5c3RlbSwgdHlwZTogbWV0cmljcyB9CiAgICAgICAgICAgIG1ldHJpY3NldHM6IFtmaWxlc3lzdGVtXQogICAgICAgICAgICBwZXJpb2Q6IDFtCg==" | base64 -d > manifests/elastic-agent-standalone.yaml
root@eck-lab:~# kubectl apply -f manifests/elastic-agent-standalone.yaml
serviceaccount/elastic-agent unchanged
clusterrole.rbac.authorization.k8s.io/elastic-agent unchanged
clusterrolebinding.rbac.authorization.k8s.io/elastic-agent unchanged
agent.agent.k8s.elastic.co/elastic-agent unchanged
root@eck-lab:~# kubectl -n elastic get agent elastic-agent      # aguarde HEALTH green
NAME            HEALTH   AVAILABLE   EXPECTED   VERSION   AGE
elastic-agent   green    1           1          9.4.2     55s
root@eck-lab:~#
root@eck-lab:~# curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices/*system*?v"
root@eck-lab:~# kubectl delete -f manifests/elastic-agent-standalone.yaml
serviceaccount "elastic-agent" deleted
clusterrole.rbac.authorization.k8s.io "elastic-agent" deleted
clusterrolebinding.rbac.authorization.k8s.io "elastic-agent" deleted
agent.agent.k8s.elastic.co "elastic-agent" deleted
root@eck-lab:~# echo "YXBpVmVyc2lvbjoga2liYW5hLms4cy5lbGFzdGljLmNvL3YxCmtpbmQ6IEtpYmFuYQptZXRhZGF0YToKICBuYW1lOiBsYWIta2IKICBuYW1lc3BhY2U6IGVsYXN0aWMKc3BlYzoKICB2ZXJzaW9uOiA5LjQuMgogIGNvdW50OiAxCiAgZWxhc3RpY3NlYXJjaFJlZjoKICAgIG5hbWU6IGxhYi1lcwogIGNvbmZpZzoKICAgIHhwYWNrLmZsZWV0LmFnZW50cy5lbGFzdGljc2VhcmNoLmhvc3RzOiBbImh0dHBzOi8vbGFiLWVzLWVzLWh0dHAuZWxhc3RpYy5zdmM6OTIwMCJdCiAgICB4cGFjay5mbGVldC5hZ2VudHMuZmxlZXRfc2VydmVyLmhvc3RzOiBbImh0dHBzOi8vZmxlZXQtc2VydmVyLWFnZW50LWh0dHAuZWxhc3RpYy5zdmM6ODIyMCJdCiAgICB4cGFjay5mbGVldC5wYWNrYWdlczoKICAgICAgLSBuYW1lOiBzeXN0ZW0KICAgICAgICB2ZXJzaW9uOiBsYXRlc3QKICAgICAgLSBuYW1lOiBlbGFzdGljX2FnZW50CiAgICAgICAgdmVyc2lvbjogbGF0ZXN0CiAgICAgIC0gbmFtZTogZmxlZXRfc2VydmVyCiAgICAgICAgdmVyc2lvbjogbGF0ZXN0CiAgICB4cGFjay5mbGVldC5hZ2VudFBvbGljaWVzOgogICAgICAtIHR5cGU6IGZsZWV0LXNlcnZlcgogICAgICAgIG5hbWU6IEZsZWV0IFNlcnZlciBvbiBFQ0sgcG9saWN5CiAgICAgICAgaWQ6IGVjay1mbGVldC1zZXJ2ZXIKICAgICAgICBpc19kZWZhdWx0X2ZsZWV0X3NlcnZlcjogdHJ1ZQogICAgICAgIHBhY2thZ2VfcG9saWNpZXM6CiAgICAgICAgICAtIG5hbWU6IGZsZWV0X3NlcnZlci0xCiAgICAgICAgICAgIHBhY2thZ2U6IHsgbmFtZTogZmxlZXRfc2VydmVyIH0KICAgICAgLSB0eXBlOiBhZ2VudHBvbGljeQogICAgICAgIG5hbWU6IEVsYXN0aWMgQWdlbnQgb24gRUNLIHBvbGljeQogICAgICAgIGlkOiBlY2stYWdlbnQKICAgICAgICBpc19kZWZhdWx0OiB0cnVlCiAgICAgICAgcGFja2FnZV9wb2xpY2llczoKICAgICAgICAgIC0gbmFtZTogc3lzdGVtLTEKICAgICAgICAgICAgcGFja2FnZTogeyBuYW1lOiBzeXN0ZW0gfQo=" | base64 -d > manifests/kibana.yaml
root@eck-lab:~# kubectl apply -f manifests/kibana.yaml
kibana.kibana.k8s.elastic.co/lab-kb configured
root@eck-lab:~# echo "IyA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KIyBSRUZFUsOKTkNJQSAvIEFWQU7Dh0FETyDigJQgRWxhc3RpYyBBZ2VudCBnZXJlbmNpYWRvIHBvciBGTEVFVCBubyBFQ0suCiMgTyBGbGVldCBTZXJ2ZXIgw6kgYXBlbmFzIG91dHJvIHJlY3Vyc28gQWdlbnQgKG1vZGU6IGZsZWV0LCBmbGVldFNlcnZlckVuYWJsZWQpLgojID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0KYXBpVmVyc2lvbjogdjEKa2luZDogU2VydmljZUFjY291bnQKbWV0YWRhdGE6CiAgbmFtZTogZmxlZXQtc2VydmVyCiAgbmFtZXNwYWNlOiBlbGFzdGljCi0tLQphcGlWZXJzaW9uOiByYmFjLmF1dGhvcml6YXRpb24uazhzLmlvL3YxCmtpbmQ6IENsdXN0ZXJSb2xlCm1ldGFkYXRhOgogIG5hbWU6IGZsZWV0LXNlcnZlcgpydWxlczoKICAtIGFwaUdyb3VwczogWyIiXQogICAgcmVzb3VyY2VzOiBbInBvZHMiLCAibmFtZXNwYWNlcyIsICJub2RlcyJdCiAgICB2ZXJiczogWyJnZXQiLCAid2F0Y2giLCAibGlzdCJdCiAgLSBhcGlHcm91cHM6IFsiY29vcmRpbmF0aW9uLms4cy5pbyJdCiAgICByZXNvdXJjZXM6IFsibGVhc2VzIl0KICAgIHZlcmJzOiBbImdldCIsICJjcmVhdGUiLCAidXBkYXRlIl0KLS0tCmFwaVZlcnNpb246IHJiYWMuYXV0aG9yaXphdGlvbi5rOHMuaW8vdjEKa2luZDogQ2x1c3RlclJvbGVCaW5kaW5nCm1ldGFkYXRhOgogIG5hbWU6IGZsZWV0LXNlcnZlcgpzdWJqZWN0czoKICAtIGtpbmQ6IFNlcnZpY2VBY2NvdW50CiAgICBuYW1lOiBmbGVldC1zZXJ2ZXIKICAgIG5hbWVzcGFjZTogZWxhc3RpYwpyb2xlUmVmOgogIGtpbmQ6IENsdXN0ZXJSb2xlCiAgbmFtZTogZmxlZXQtc2VydmVyCiAgYXBpR3JvdXA6IHJiYWMuYXV0aG9yaXphdGlvbi5rOHMuaW8KLS0tCmFwaVZlcnNpb246IGFnZW50Lms4cy5lbGFzdGljLmNvL3YxYWxwaGExCmtpbmQ6IEFnZW50Cm1ldGFkYXRhOgogIG5hbWU6IGZsZWV0LXNlcnZlcgogIG5hbWVzcGFjZTogZWxhc3RpYwpzcGVjOgogIHZlcnNpb246IDkuNC4yCiAga2liYW5hUmVmOgogICAgbmFtZTogbGFiLWtiCiAgZWxhc3RpY3NlYXJjaFJlZnM6CiAgICAtIG5hbWU6IGxhYi1lcwogIG1vZGU6IGZsZWV0CiAgZmxlZXRTZXJ2ZXJFbmFibGVkOiB0cnVlCiAgcG9saWN5SUQ6IGVjay1mbGVldC1zZXJ2ZXIKICBkZXBsb3ltZW50OgogICAgcmVwbGljYXM6IDEKICAgIHBvZFRlbXBsYXRlOgogICAgICBzcGVjOgogICAgICAgIHNlcnZpY2VBY2NvdW50TmFtZTogZmxlZXQtc2VydmVyCiAgICAgICAgYXV0b21vdW50U2VydmljZUFjY291bnRUb2tlbjogdHJ1ZQogICAgICAgIHNlY3VyaXR5Q29udGV4dDoKICAgICAgICAgIHJ1bkFzVXNlcjogMAotLS0KYXBpVmVyc2lvbjogYWdlbnQuazhzLmVsYXN0aWMuY28vdjFhbHBoYTEKa2luZDogQWdlbnQKbWV0YWRhdGE6CiAgbmFtZTogZWxhc3RpYy1hZ2VudC1mbGVldAogIG5hbWVzcGFjZTogZWxhc3RpYwpzcGVjOgogIHZlcnNpb246IDkuNC4yCiAga2liYW5hUmVmOgogICAgbmFtZTogbGFiLWtiCiAgZmxlZXRTZXJ2ZXJSZWY6CiAgICBuYW1lOiBmbGVldC1zZXJ2ZXIKICBtb2RlOiBmbGVldAogIHBvbGljeUlEOiBlY2stYWdlbnQKICBkYWVtb25TZXQ6CiAgICBwb2RUZW1wbGF0ZToKICAgICAgc3BlYzoKICAgICAgICBzZXJ2aWNlQWNjb3VudE5hbWU6IGVsYXN0aWMtYWdlbnQKICAgICAgICBhdXRvbW91bnRTZXJ2aWNlQWNjb3VudFRva2VuOiB0cnVlCiAgICAgICAgaG9zdE5ldHdvcms6IHRydWUKICAgICAgICBkbnNQb2xpY3k6IENsdXN0ZXJGaXJzdFdpdGhIb3N0TmV0CiAgICAgICAgc2VjdXJpdHlDb250ZXh0OgogICAgICAgICAgcnVuQXNVc2VyOiAwCg==" | base64 -d > manifests/fleet-referencia.yaml

kubectl apply -f manifests/fleet-referencia.yaml
kubectl -n elastic get agent -w
serviceaccount/fleet-server created
clusterrole.rbac.authorization.k8s.io/fleet-server created
clusterrolebinding.rbac.authorization.k8s.io/fleet-server created
agent.agent.k8s.elastic.co/fleet-server created
agent.agent.k8s.elastic.co/elastic-agent-fleet created
NAME                  HEALTH   AVAILABLE   EXPECTED   VERSION   AGE
elastic-agent-fleet                                             0s
fleet-server                                                    0s
fleet-server                                                    0s
fleet-server                                                    0s
fleet-server                                                    0s
elastic-agent-fleet                                             1s
elastic-agent-fleet                                             1s
fleet-server                                                    1s
elastic-agent-fleet                                             1s
fleet-server                                                    1s
elastic-agent-fleet                                             2s
elastic-agent-fleet                                             2s
Handling connection for 5601
Handling connection for 5601
^Croot@eck-lab:~kubectl apply -f manifests/fleet-referencia.yamlml
kubectl -n elastic get agent -w
serviceaccount/fleet-server unchanged
clusterrole.rbac.authorization.k8s.io/fleet-server unchanged
clusterrolebinding.rbac.authorization.k8s.io/fleet-server unchanged
agent.agent.k8s.elastic.co/fleet-server unchanged
agent.agent.k8s.elastic.co/elastic-agent-fleet unchanged
NAME                  HEALTH   AVAILABLE   EXPECTED   VERSION   AGE
elastic-agent-fleet                                             34s
fleet-server                                                    34s
^Croot@eck-lab:~kubectl apply -f manifests/fleet-referencia.yamlml
serviceaccount/fleet-server unchanged
clusterrole.rbac.authorization.k8s.io/fleet-server unchanged
clusterrolebinding.rbac.authorization.k8s.io/fleet-server unchanged
agent.agent.k8s.elastic.co/fleet-server unchanged
agent.agent.k8s.elastic.co/elastic-agent-fleet unchanged
root@eck-lab:~# kubectl -n elastic get agent -w
NAME                  HEALTH   AVAILABLE   EXPECTED   VERSION   AGE
elastic-agent-fleet                                             51s
fleet-server                                                    51s
^Croot@eck-lab:~kubectl apply -f manifests/fleet-referencia.yamlml
serviceaccount/fleet-server unchanged
clusterrole.rbac.authorization.k8s.io/fleet-server unchanged
clusterrolebinding.rbac.authorization.k8s.io/fleet-server unchanged
agent.agent.k8s.elastic.co/fleet-server unchanged
agent.agent.k8s.elastic.co/elastic-agent-fleet unchanged
root@eck-lab:~# kubectl -n elastic get agent                      # fleet-server e elastic-agent-fleet
NAME                  HEALTH   AVAILABLE   EXPECTED   VERSION   AGE
elastic-agent-fleet                                             72s
fleet-server