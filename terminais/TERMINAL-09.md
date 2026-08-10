root@eck-lab:~# kubectl -n elastic port-forward service/lab-kb-http 5601
Error from server (NotFound): services "lab-kb-http" not found
root@eck-lab:~# Handling connection for 5601
^C
root@eck-lab:~# kubectl -n elastic get svc | grep kb
lab-kb-kb-http                ClusterIP   10.103.196.68    <none>        5601/TCP   2d23h
quickstart-kb-http            ClusterIP   10.106.3.34      <none>        5601/TCP   3d
root@eck-lab:~# kubectl -n elastic port-forward service/lab-kb-kb-http 5601
Forwarding from [::1]:5601 -> 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
^Croot@eck-lab:~source _assets/versions.envnv
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
root@eck-lab:~# kubectl apply -n elastic -f manifests/lab-es-ml.yaml
error: the path "manifests/lab-es-ml.yaml" does not exist
root@eck-lab:~# kubectl -n elastic get elasticsearch lab-es -w      # aguarde green; Ctrl+C
NAME     HEALTH   NODES   VERSION   PHASE   AGE
lab-es   yellow   1       9.4.2     Ready   2d19h
root@eck-lab:~# mkdir -p manifeststs
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
root@eck-lab:~# kubectl apply -n elastic -f manifests/lab-es-ml.yaml
elasticsearch.elasticsearch.k8s.elastic.co/lab-es configured
root@eck-lab:~# kubectl -n elastic get elasticsearch lab-es -w
NAME     HEALTH   NODES   VERSION   PHASE             AGE
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
lab-es   yellow           9.4.2     ApplyingChanges   2d19h
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
lab-es   yellow           9.4.2     ApplyingChanges   2d19h
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
lab-es   yellow           9.4.2     ApplyingChanges   2d19h
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
^Croot@eck-lab:~mkdir -p manifeststs
echo "IyBDbHVzdGVyIGRvIGxhYiBjb20gbyBwYXBlbCBkZSBuw7MgIm1sIiBoYWJpbGl0YWRvIChNw7NkdWxvIDA5KS4KIyBIZWFwIGUgbWVtw7NyaWEgbWFpb3JlcyBwb3JxdWUgTUwgY29uc29tZSBSQU0gQUzDiU0gZG8gaGVhcCBkYSBKVk0uCiMgQVRFTsOHw4NPICgxNiBHQik6IHJvZGUgaXNvbGFkbzsgcGFyZSBjb2xldG9yZXMvb3V0cm9zIGNsdXN0ZXJzIGFudGVzLgphcGlWZXJzaW9uOiBlbGFzdGljc2VhcmNoLms4cy5lbGFzdGljLmNvL3YxCmtpbmQ6IEVsYXN0aWNzZWFyY2gKbWV0YWRhdGE6CiAgbmFtZTogbGFiLWVzCnNwZWM6CiAgdmVyc2lvbjogOS40LjIKICBub2RlU2V0czoKICAgIC0gbmFtZTogZGVmYXVsdAogICAgICBjb3VudDogMQogICAgICBjb25maWc6CiAgICAgICAgIyAnbWwnIGhhYmlsaXRhIGpvYnMgZGUgTWFjaGluZSBMZWFybmluZyBuZXN0ZSBuw7MuCiAgICAgICAgbm9kZS5yb2xlczogWyJtYXN0ZXIiLCAiZGF0YSIsICJpbmdlc3QiLCAibWwiLCAicmVtb3RlX2NsdXN0ZXJfY2xpZW50Il0KICAgICAgICBub2RlLnN0b3JlLmFsbG93X21tYXA6IHRydWUKICAgICAgcG9kVGVtcGxhdGU6CiAgICAgICAgc3BlYzoKICAgICAgICAgIGNvbnRhaW5lcnM6CiAgICAgICAgICAgIC0gbmFtZTogZWxhc3RpY3NlYXJjaAogICAgICAgICAgICAgIGVudjoKICAgICAgICAgICAgICAgIC0gbmFtZTogRVNfSkFWQV9PUFRTCiAgICAgICAgICAgICAgICAgIHZhbHVlOiAtWG1zM2cgLVhteDNnICAgICAgICAgICMgaGVhcCAzIEdCCiAgICAgICAgICAgICAgcmVxdWVzdHM6CiAgICAgICAgICAgICAgICByZXF1ZXN0czoKICAgICAgICAgICAgICAgICAgbWVtb3J5OiA2R2kKICAgICAgICAgICAgICAgICAgY3B1OiAiMiIKICAgICAgICAgICAgICAgIGxpbWl0czoKICAgICAgICAgICAgICAgICAgbWVtb3J5OiA2R2kKICAgICAgdm9sdW1lQ2xhaW1UZW1wbGF0ZXM6CiAgICAgICAgLSBtZXRhZGF0YTogeyBuYW1lOiBlbGFzdGljc2VhcmNoLWRhdGEgfQogICAgICAgICAgc3BlYzoKICAgICAgICAgICAgYWNjZXNzTW9kZXM6IFtSZWFkV3JpdGVPbmNlXQogICAgICAgICAgICByZXF1ZXN0czoKICAgICAgICAgICAgICBzdG9yYWdlOiAyMEdpCiAgICAgICAgICAgIHN0b3JhZ2VDbGFzc05hbWU6IGxvY2FsLXBhdGgK" | base64 -d > manifests/lab-es-ml.yaml

kubectl apply -n elastic -f manifests/lab-es-ml.yaml
kubectl -n elastic get elasticsearch lab-es -w
The request is invalid: patch: Invalid value: "{\"apiVersion\":\"elasticsearch.k8s.elastic.co/v1\",\"kind\":\"Elasticsearch\",\"metadata\":{\"annotations\":{\"eck.k8s.elastic.co/orchestration-hints\":\"{\\\"no_transient_settings\\\":true,\\\"service_accounts\\\":true,\\\"desired_nodes\\\":{\\\"version\\\":4,\\\"hash\\\":\\\"733944211\\\"}}\",\"elasticsearch.k8s.elastic.co/cluster-uuid\":\"7qgqx9YlTrWedqjgENLJMA\",\"kubectl.kubernetes.io/last-applied-configuration\":\"{\\\"apiVersion\\\":\\\"elasticsearch.k8s.elastic.co/v1\\\",\\\"kind\\\":\\\"Elasticsearch\\\",\\\"metadata\\\":{\\\"annotations\\\":{},\\\"name\\\":\\\"lab-es\\\",\\\"namespace\\\":\\\"elastic\\\"},\\\"spec\\\":{\\\"nodeSets\\\":[{\\\"config\\\":{\\\"node.roles\\\":[\\\"master\\\",\\\"data\\\",\\\"ingest\\\",\\\"ml\\\",\\\"remote_cluster_client\\\"],\\\"node.store.allow_mmap\\\":true},\\\"count\\\":1,\\\"name\\\":\\\"default\\\",\\\"podTemplate\\\":{\\\"spec\\\":{\\\"containers\\\":[{\\\"env\\\":[{\\\"name\\\":\\\"ES_JAVA_OPTS\\\",\\\"value\\\":\\\"-Xms3g -Xmx3g\\\"}],\\\"name\\\":\\\"elasticsearch\\\",\\\"requests\\\":{\\\"limits\\\":{\\\"memory\\\":\\\"6Gi\\\"},\\\"requests\\\":{\\\"cpu\\\":\\\"2\\\",\\\"memory\\\":\\\"6Gi\\\"}}}]}},\\\"volumeClaimTemplates\\\":[{\\\"metadata\\\":{\\\"name\\\":\\\"elasticsearch-data\\\"},\\\"spec\\\":{\\\"accessModes\\\":[\\\"ReadWriteOnce\\\"],\\\"requests\\\":{\\\"storage\\\":\\\"20Gi\\\"},\\\"storageClassName\\\":\\\"local-path\\\"}}]}],\\\"version\\\":\\\"9.4.2\\\"}}\\n\"},\"creationTimestamp\":\"2026-08-07T17:58:03Z\",\"generation\":5,\"managedFields\":[{\"apiVersion\":\"elasticsearch.k8s.elastic.co/v1\",\"fieldsType\":\"FieldsV1\",\"fieldsV1\":{\"f:metadata\":{\"f:annotations\":{\".\":{},\"f:kubectl.kubernetes.io/last-applied-configuration\":{}}},\"f:spec\":{\".\":{},\"f:version\":{}}},\"manager\":\"kubectl-client-side-apply\",\"operation\":\"Update\",\"time\":\"2026-08-10T13:43:48Z\"},{\"apiVersion\":\"elasticsearch.k8s.elastic.co/v1\",\"fieldsType\":\"FieldsV1\",\"fieldsV1\":{\"f:metadata\":{\"f:annotations\":{\"f:eck.k8s.elastic.co/orchestration-hints\":{},\"f:elasticsearch.k8s.elastic.co/cluster-uuid\":{}}},\"f:spec\":{\"f:auth\":{},\"f:http\":{\".\":{},\"f:service\":{\".\":{},\"f:metadata\":{},\"f:spec\":{}},\"f:tls\":{\".\":{},\"f:certificate\":{},\"f:client\":{}}},\"f:monitoring\":{\".\":{},\"f:logs\":{},\"f:metrics\":{}},\"f:nodeSets\":{},\"f:remoteClusterServer\":{\".\":{},\"f:service\":{\".\":{},\"f:metadata\":{},\"f:spec\":{}}},\"f:transport\":{\".\":{},\"f:service\":{\".\":{},\"f:metadata\":{},\"f:spec\":{}},\"f:tls\":{\".\":{},\"f:certificate\":{},\"f:certificateAuthorities\":{}}},\"f:updateStrategy\":{\".\":{},\"f:changeBudget\":{}}}},\"manager\":\"elastic-operator\",\"operation\":\"Update\",\"time\":\"2026-08-10T13:43:49Z\"},{\"apiVersion\":\"elasticsearch.k8s.elastic.co/v1\",\"fieldsType\":\"FieldsV1\",\"fieldsV1\":{\"f:status\":{\".\":{},\"f:availableNodes\":{},\"f:conditions\":{},\"f:health\":{},\"f:inProgressOperations\":{\".\":{},\"f:downscale\":{\".\":{},\"f:lastUpdatedTime\":{}},\"f:upgrade\":{\".\":{},\"f:lastUpdatedTime\":{},\"f:nodes\":{}},\"f:upscale\":{\".\":{},\"f:lastUpdatedTime\":{}}},\"f:observedGeneration\":{},\"f:phase\":{},\"f:version\":{}}},\"manager\":\"elastic-operator\",\"operation\":\"Update\",\"subresource\":\"status\",\"time\":\"2026-08-10T13:44:49Z\"}],\"name\":\"lab-es\",\"namespace\":\"elastic\",\"resourceVersion\":\"605780\",\"uid\":\"5421aedf-79b5-4188-bc9c-e6d44c61116c\"},\"spec\":{\"auth\":{},\"http\":{\"service\":{\"metadata\":{},\"spec\":{}},\"tls\":{\"certificate\":{},\"client\":{}}},\"monitoring\":{\"logs\":{},\"metrics\":{}},\"nodeSets\":[{\"config\":{\"node.roles\":[\"master\",\"data\",\"ingest\",\"ml\",\"remote_cluster_client\"],\"node.store.allow_mmap\":true},\"count\":1,\"name\":\"default\",\"podTemplate\":{\"spec\":{\"containers\":[{\"env\":[{\"name\":\"ES_JAVA_OPTS\",\"value\":\"-Xms3g -Xmx3g\"}],\"name\":\"elasticsearch\",\"requests\":{\"limits\":{\"memory\":\"6Gi\"},\"requests\":{\"cpu\":\"2\",\"memory\":\"6Gi\"}}}]}},\"volumeClaimTemplates\":[{\"metadata\":{\"name\":\"elasticsearch-data\"},\"spec\":{\"accessModes\":[\"ReadWriteOnce\"],\"requests\":{\"storage\":\"20Gi\"},\"storageClassName\":\"local-path\"}}]}],\"remoteClusterServer\":{\"service\":{\"metadata\":{},\"spec\":{}}},\"transport\":{\"service\":{\"metadata\":{},\"spec\":{}},\"tls\":{\"certificate\":{},\"certificateAuthorities\":{}}},\"updateStrategy\":{\"changeBudget\":{}},\"version\":\"9.4.2\"},\"status\":{\"availableNodes\":1,\"conditions\":[{\"lastTransitionTime\":\"2026-08-10T13:43:49Z\",\"message\":\"Nodes upgrade in progress\",\"status\":\"False\",\"type\":\"ReconciliationComplete\"},{\"lastTransitionTime\":\"2026-08-07T17:58:04Z\",\"message\":\"All nodes are running version 9.4.2\",\"status\":\"True\",\"type\":\"RunningDesiredVersion\"},{\"lastTransitionTime\":\"2026-08-07T17:58:55Z\",\"message\":\"Service elastic/lab-es-es-internal-http has endpoints\",\"status\":\"True\",\"type\":\"ElasticsearchIsReachable\"},{\"lastTransitionTime\":\"2026-08-10T13:43:49Z\",\"message\":\"Successfully calculated compute and storage resources from Elasticsearch resource generation 5\",\"status\":\"True\",\"type\":\"ResourcesAwareManagement\"}],\"health\":\"yellow\",\"inProgressOperations\":{\"downscale\":{\"lastUpdatedTime\":\"2026-08-07T17:58:04Z\"},\"upgrade\":{\"lastUpdatedTime\":\"2026-08-10T13:44:49Z\",\"nodes\":[{\"name\":\"lab-es-es-default-0\",\"status\":\"PENDING\"}]},\"upscale\":{\"lastUpdatedTime\":\"2026-08-07T17:58:04Z\"}},\"observedGeneration\":5,\"phase\":\"ApplyingChanges\",\"version\":\"9.4.2\"}}": strict decoding error: unknown field "spec.nodeSets[0].volumeClaimTemplates[0].spec.requests"
NAME     HEALTH   NODES   VERSION   PHASE             AGE
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
lab-es   yellow           9.4.2     ApplyingChanges   2d19h
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
lab-es   yellow           9.4.2     ApplyingChanges   2d19h
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
lab-es   yellow           9.4.2     ApplyingChanges   2d19h
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
lab-es   yellow           9.4.2     ApplyingChanges   2d19h
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
^Croot@eck-lab:~kubectl -n elastic get pods -l elasticsearch.k8s.elastic.co/cluster-name=lab-es -w-w
NAME                  READY   STATUS    RESTARTS   AGE
lab-es-es-default-0   0/1     Running   0          2d19h
lab-es-es-default-0   1/1     Running   0          2d19h
^Croot@eck-lab:~kubectl -n elastic get es lab-eses
NAME     HEALTH   NODES   VERSION   PHASE             AGE
lab-es   yellow   1       9.4.2     ApplyingChanges   2d19h
root@eck-lab:~# Handling connection for 5601
Handling connection for 5601