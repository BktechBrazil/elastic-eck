root@eck-lab:~# pwd
/root
root@eck-lab:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
root@eck-lab:~# kubectl -n elastic port-forward service/lab-es-es-http 9200 &
[1] 1450289
root@eck-lab:~# Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
^C
root@eck-lab:~# alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
root@eck-lab:~# es "/_cat/allocation?v"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "7qgqx9YlTrWedqjgENLJMA",
  "version" : {
    "number" : "9.4.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "77cd231096e56b56ac1d24445a9430a252622e6d",
    "build_date" : "2026-07-15T22:13:42.125968334Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@eck-lab:~# es "/_cat/nodes?v&h=name,heap.percent,ram.percent,cpu,load_1m,disk.used_percent"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "7qgqx9YlTrWedqjgENLJMA",
  "version" : {
    "number" : "9.4.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "77cd231096e56b56ac1d24445a9430a252622e6d",
    "build_date" : "2026-07-15T22:13:42.125968334Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@eck-lab:~# kubectl top nodes
NAME      CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
eck-lab   973m         12%    9974Mi          41%
root@eck-lab:~# kubectl top pods -n elastic
NAME                                  CPU(cores)   MEMORY(bytes)
fleet-server-agent-68f7688db7-plsp2   11m          246Mi
lab-es-es-default-0                   93m          3350Mi
lab-kb-kb-6955f8b4f5-lttsb            44m          1005Mi
quickstart-es-default-0               53m          3592Mi
quickstart-kb-65587bf788-xqrc5        301m         1028Mi
root@eck-lab:~# es "/_cat/shards?v" | wc -l
Handling connection for 9200
17
root@eck-lab:~# es "/_cluster/health?pretty" | grep -E 'active_shards|number_of_nodes'
Handling connection for 9200
root@eck-lab:~# kubectl apply -n elastic -f manifests/lab-es-sized.yaml
error: the path "manifests/lab-es-sized.yaml" does not exist
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/lab-es-sized.yaml
# Exemplo de dimensionamento consciente (Módulo 11).
# request == limit de memória (garantida); heap = 50% do request; CPU com request e sem limit.
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: lab-es
spec:
  version: 9.4.4
  nodeSets:
    - name: default
      count: 1                     # escale horizontalmente mudando este valor
      config:
        node.store.allow_mmap: true
      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              env:
                - name: ES_JAVA_OPTS
                  value: -Xms3g -Xmx3g       # 50% do requests.memory (6Gi)
              resources:
                requests:
                  memory: 6Gi
                  cpu: "2"
                limits:
                  memory: 6Gi              # == request: memória garantida (evita OOM/eviction)
                  # sem limits.cpu: permite bursts sem throttling
      volumeClaimTemplates:
        - metadata: { name: elasticsearch-data }
          spec:
            accessModes: [ReadWriteOnce]
            resources: { requests: { storage: 30Gi } }
            storageClassName: local-path   # precisa de allowVolumeExpansion p/ crescer depois
EOF
root@eck-lab:~# kubectl apply -n elastic -f manifests/lab-es-sized.yaml
elasticsearch.elasticsearch.k8s.elastic.co/lab-es configured
root@eck-lab:~# kubectl -n elastic get pods -w
NAME                                  READY   STATUS    RESTARTS   AGE
fleet-server-agent-68f7688db7-plsp2   1/1     Running   0          72m
lab-es-es-default-0                   1/1     Running   0          3d4h
lab-kb-kb-6955f8b4f5-lttsb            1/1     Running   0          74m
quickstart-es-default-0               1/1     Running   0          6d5h
quickstart-kb-65587bf788-xqrc5        1/1     Running   0          6d5h
^Croot@eck-lab:~es "/_nodes/jvm?filter_path=**.mem.heap_max_in_bytes"s"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "7qgqx9YlTrWedqjgENLJMA",
  "version" : {
    "number" : "9.4.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "77cd231096e56b56ac1d24445a9430a252622e6d",
    "build_date" : "2026-07-15T22:13:42.125968334Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@eck-lab:~# nano manifests/
elastic-agent-standalone.yaml  filebeat-para-logstash.yaml    kibana-quickstart.yaml         logstash.yaml
elasticsearch-9.4.4.yaml       filebeat.yaml                  kibana.yaml                    topo-es.yaml
elasticsearch-quickstart.yaml  fleet-referencia.yaml          lab-es-ml.yaml
elasticsearch.yaml             kibana-9.4.4.yaml              lab-es-sized.yaml
root@eck-lab:~# nano manifests/lab-es-sized.yaml
root@eck-lab:~# kubectl apply -n elastic -f manifests/lab-es-sized.yaml
elasticsearch.elasticsearch.k8s.elastic.co/lab-es configured
root@eck-lab:~# es "/_cat/nodes?v&h=name,node.role"      # dois nós
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "7qgqx9YlTrWedqjgENLJMA",
  "version" : {
    "number" : "9.4.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "77cd231096e56b56ac1d24445a9430a252622e6d",
    "build_date" : "2026-07-15T22:13:42.125968334Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@eck-lab:~# es "/_cat/allocation?v"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "7qgqx9YlTrWedqjgENLJMA",
  "version" : {
    "number" : "9.4.4",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "77cd231096e56b56ac1d24445a9430a252622e6d",
    "build_date" : "2026-07-15T22:13:42.125968334Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@eck-lab:~#