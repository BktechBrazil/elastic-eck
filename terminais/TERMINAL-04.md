root@vmi3487682:~# source ../_assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
-bash: ../_assets/versions.env: No such file or directory
[8] 98064
root@vmi3487682:~# Unable to listen on port 9200: Listeners failed to create with the following errors: [unable to create listener: Error listen tcp4 127.0.0.1:9200: bind: address already in use unable to create listener: Error listen tcp6 [::1]:9200: bind: address already in use]
error: unable to listen on any of the requested ports: [{9200 9200}]
^C
[8]+  Exit 1                  kubectl -n elastic port-forward service/lab-es-es-http 9200
root@vmi3487682:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
[8] 100774
root@vmi3487682:~# Unable to listen on port 9200: Listeners failed to create with the following errors: [unable to create listener: Error listen tcp4 127.0.0.1:9200: bind: address already in use unable to create listener: Error listen tcp6 [::1]:9200: bind: address already in use]
error: unable to listen on any of the requested ports: [{9200 9200}]
^C
[8]+  Exit 1                  kubectl -n elastic port-forward service/lab-es-es-http 9200
root@vmi3487682:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
pkill -f "port-forward.*9200" || true
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
[8] 101346
Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
[7]-  Terminated              kubectl -n elastic port-forward service/lab-es-es-http 9200
root@vmi3487682:~# es "/_cat/nodes?v&h=name,node.role,heap.percent,cpu,disk.used_percent"
es "/_cat/shards/kibana_sample_data_ecommerce?v"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "Z80CqjewS0GgF7pINRG5KA",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "Z80CqjewS0GgF7pINRG5KA",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es -X PUT "/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'
es "/_cat/shards/loja?v"
Handling connection for 9200
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "Z80CqjewS0GgF7pINRG5KA",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es "/loja?pretty" -X PUT -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'

es "/_cat/shards/loja?v"
Handling connection for 9200
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "Z80CqjewS0GgF7pINRG5KA",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# unalias es 2>/dev/null || true

curl -sk -u "elastic:$PASSWORD" -X PUT "https://localhost:9200/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'

curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/shards/loja?v"
Handling connection for 9200
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "loja"
}
Handling connection for 9200
index shard prirep state      docs store dataset ip              node
loja  0     p      STARTED       0    0b      0b 192.168.149.145 lab-es-es-default-0
loja  0     r      UNASSIGNED
loja  1     p      STARTED       0    0b      0b 192.168.149.145 lab-es-es-default-0
loja  1     r      UNASSIGNED
loja  2     p      STARTED       0  227b    227b 192.168.149.145 lab-es-es-default-0
loja  2     r      UNASSIGNED
root@vmi3487682:~# curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cluster/health/loja?pretty"
Handling connection for 9200
{
  "cluster_name" : "lab-es",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 3,
  "active_shards" : 3,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 3,
  "unassigned_primary_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
root@vmi3487682:~# curl -sk -u "elastic:$PASSWORD" -X PUT "https://localhost:9200/loja/_settings?pretty" -H 'Content-Type: application/json' -d '{
  "index": { "number_of_replicas": 0 }
}'

curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cluster/health/loja?pretty"
Handling connection for 9200
{
  "acknowledged" : true
}
Handling connection for 9200
{
  "cluster_name" : "lab-es",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 3,
  "active_shards" : 3,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "unassigned_primary_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
root@vmi3487682:~# Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
E0807 17:19:17.441011   67033 portforward.go:398] "Unhandled Error" err="error copying from local connection to remote stream: writeto tcp4 207.244.255.225:5601->189.85.89.228:61694: read tcp4 207.244.255.225:5601->189.85.89.228:61694: read: connection reset by peer"
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601
Handling connection for 5601

root@vmi3487682:~# ls -la
total 60
-rw-r--r--  1 root root    0 Aug  7 15:42  --resolve
-rw-r--r--  1 root root    0 Aug  7 15:42  -u
drwx------  9 root root 4096 Aug  7 16:43  .
drwxr-xr-x 19 root root 4096 Aug  6 22:10  ..
-rw-------  1 root root  123 Aug  7 13:51  .bash_history
-rw-r--r--  1 root root 3106 Oct 15  2021  .bashrc
drwx------  3 root root 4096 Aug  7 14:48  .cache
drwxr-xr-x  3 root root 4096 Aug  7 14:48  .config
drwxr-xr-x  3 root root 4096 Aug  7 14:46  .kube
-rw-------  1 root root   20 Aug  7 15:12  .lesshst
-rw-r--r--  1 root root  161 Jul  9  2019  .profile
drwx------  2 root root 4096 Aug  6 22:10  .ssh
-rw-r--r--  1 root root    0 Aug  7 16:43 'PASSWORD=oKH0OxYgERRBMVeIyCCOofBC'
drwxr-xr-x  2 root root 4096 Aug  7 14:35  _assets
-rw-r--r--  1 root root 1180 Aug  7 15:44  ca.crt
-rw-r--r--  1 root root    0 Aug  7 16:32  curl
-rw-r--r--  1 root root    0 Aug  7 16:43  kubectl
drwxr-xr-x  2 root root 4096 Aug  7 15:23  manifests
-rw-r--r--  1 root root    0 Aug  7 16:43  pkill
-rw-r--r--  1 root root    0 Aug  7 16:43  sleep
drwx------  3 root root 4096 Aug  6 22:10  snap
-rw-r--r--  1 root root    0 Aug  7 16:32  source
-rw-r--r--  1 root root 2664 Aug  7 15:44  tls.crt
root@vmi3487682:~#
root@vmi3487682:~# kubectl -n elastic delete elasticsearch lab-es
kubectl apply -n elastic -f manifests/topo-es.yaml
kubectl -n elastic get elasticsearch topo-es -w
elasticsearch.elasticsearch.k8s.elastic.co "lab-es" deleted
error: the path "manifests/topo-es.yaml" does not exist
Error from server (NotFound): elasticsearches.elasticsearch.k8s.elastic.co "topo-es" not found
root@vmi3487682:~# es -X PUT "/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'
es "/_cat/shards/loja?v"
es: command not found
es: command not found
root@vmi3487682:~# kubectl -n elastic delete elasticsearch topo-es && kubectl apply -n elastic -f ../02-deploy-elastic-stack-eck/manifests/elasticsearch.yaml
Error from server (NotFound): elasticsearches.elasticsearch.k8s.elastic.co "topo-es" not found
root@vmi3487682:~# Handling connection for 5601
^C
root@vmi3487682:~# unalias es 2>/dev/null || true

curl -sk -u "elastic:$PASSWORD" -X PUT "https://localhost:9200/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'

curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/shards/loja?v"
Handling connection for 9200
E0807 19:15:33.435457  101346 portforward.go:413] "Unhandled Error" err="an error occurred forwarding 9200 -> 9200: error forwarding port 9200 to pod aa99f4929e4a45bd37683829a2f5c87a1207eb4e1206d6669eb6ac6cf54d64f0, uid : failed to find sandbox \"aa99f4929e4a45bd37683829a2f5c87a1207eb4e1206d6669eb6ac6cf54d64f0\" in store: not found"
error: lost connection to pod
[8]+  Exit 1                  kubectl -n elastic port-forward service/lab-es-es-http 9200
root@vmi3487682:~#
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: quickstart
spec:
  version: 9.4.2
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
                requests:
                  memory: 4Gi
                  cpu: "1"
                limits:
                  memory: 4Gi
      volumeClaimTemplates:
        - metadata:
            name: elasticsearch-data
          spec:
            accessModes:
              - ReadWriteOnce
            resources:
              requests:
                storage: 20Gi
            storageClassName: local-path
EOF
root@vmi3487682:~#
root@vmi3487682:~# Handling connection for 5601
Handling connection for 5601
source _assets/verssource _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
pkill -f "port-forward.*9200" || true
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
Error from server (NotFound): secrets "lab-es-es-elastic-user" not found
[5] 187831
Error from server (NotFound): services "lab-es-es-http" not found
[5]+  Exit 1                  kubectl -n elastic port-forward service/lab-es-es-http 9200
root@vmi3487682:~# ^C
root@vmi3487682:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
pkill -f "port-forward.*9200" || true
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
Error from server (NotFound): secrets "lab-es-es-elastic-user" not found
[5] 187873
Error from server (NotFound): services "lab-es-es-http" not found
[5]+  Exit 1                  kubectl -n elastic port-forward service/lab-es-es-http 9200
root@vmi3487682:~# kubectl apply -n elastic -f manifests/elasticsearch.yaml
elasticsearch.elasticsearch.k8s.elastic.co/lab-es created
root@vmi3487682:~# kubectl -n elastic get elasticsearch lab-es -w
NAME     HEALTH   NODES   VERSION   PHASE   AGE
lab-es   green    1       9.4.2     Ready   4m19s
^Croot@vmi3487682:~#
root@vmi3487682:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
pkill -f "port-forward.*9200" || true
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
[5] 195810
Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
root@vmi3487682:~# es "/_cat/nodes?v&h=name,node.role,heap.percent,cpu,disk.used_percent"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es "/_cat/shards/kibana_sample_data_ecommerce?v"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es -X PUT "/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'
es "/_cat/shards/loja?v"
Handling connection for 9200
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~#
root@vmi3487682:~# es -X PUT "/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'
es "/_cat/shards/loja?v"
Handling connection for 9200
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~#
root@vmi3487682:~# es -X PUT "/loja?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'
Handling connection for 9200
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}root@vmi3487682:~curl -sk -u "elastic:$PASSWORD" -X PUT "https://localhost:9200/loja?pretty" -H 'Content-Type: application/json' -d '{'{
  "settings": { "number_of_shards": 3, "number_of_replicas": 1 }
}'
curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cat/shards/loja?v"
Handling connection for 9200
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "loja"
}
Handling connection for 9200
index shard prirep state      docs store dataset ip              node
loja  0     p      STARTED       0  190b    190b 192.168.149.149 lab-es-es-default-0
loja  0     r      UNASSIGNED
loja  1     p      STARTED       0    0b      0b 192.168.149.149 lab-es-es-default-0
loja  1     r      UNASSIGNED
loja  2     p      STARTED       0  227b    227b 192.168.149.149 lab-es-es-default-0
loja  2     r      UNASSIGNED
root@vmi3487682:~# es "/_cat/shards/loja?v"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es "/_cluster/health/loja?pretty"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es -X PUT "/loja/_settings" -H 'Content-Type: application/json' -d '{ "index": { "number_of_replicas": 0 } }'
es "/_cluster/health/loja?pretty"      # agora "green"
Handling connection for 9200
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es -X PUT "/loja/_settings" -H 'Content-Type: application/json' -d '{ "index": { "number_of_replicas": 0 } }'
Handling connection for 9200
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}root@vmi3487682:~es "/_cluster/health/loja?pretty" "
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# curl -sk -u "elastic:$PASSWORD" -X PUT "https://localhost:9200/loja/_settings?pretty" -H 'Content-Type: application/json' -d '{ "index": { "number_of_replicas": 0 } }'
curl -sk -u "elastic:$PASSWORD" "https://localhost:9200/_cluster/health/loja?pretty"
Handling connection for 9200
{
  "acknowledged" : true
}
Handling connection for 9200
{
  "cluster_name" : "lab-es",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 3,
  "active_shards" : 3,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "unassigned_primary_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
root@vmi3487682:~# es "/_cluster/health/loja?pretty"
Handling connection for 9200
{
  "name" : "lab-es-es-default-0",
  "cluster_name" : "lab-es",
  "cluster_uuid" : "CcXfQM6mQIah7jne7LWKdQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~#
root@vmi3487682:~# kubectl -n elastic delete elasticsearch lab-es
elasticsearch.elasticsearch.k8s.elastic.co "lab-es" deleted
root@vmi3487682:~# kubectl apply -n elastic -f manifests/topo-es.yaml
error: the path "manifests/topo-es.yaml" does not exist
root@vmi3487682:~# mkdir -p manifests
cat << 'EOF' > manifests/topo-es.yaml
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: topo-es
spec:
  version: 9.4.2
  nodeSets:
    - name: default
      count: 2
      config:
        node.store.allow_mmap: true
      podTemplate:
        spec:
          containers:
            - name: elasticsearch
              env:
                - name: ES_JAVA_OPTS
                  value: -Xms1g -Xmx1g
              resources:
                requests:
                  memory: 2Gi
                  cpu: "500m"
                limits:
                  memory: 2Gi
      volumeClaimTemplates:
        - metadata:
            name: elasticsearch-data
          spec:
            accessModes: [ReadWriteOnce]
            resources:
              requests:
                storage: 10Gi
            storageClassName: local-path
EOF
root@vmi3487682:~# kubectl apply -n elastic -f manifests/topo-es.yaml
elasticsearch.elasticsearch.k8s.elastic.co/topo-es created
root@vmi3487682:~# kubectl -n elastic get elasticsearch topo-es -w      # aguarde green; Ctrl+C
NAME      HEALTH   NODES   VERSION   PHASE   AGE
topo-es   green    2       9.4.2     Ready   2m23s
^Croot@vmi3487682:~PASSWORD=$(kubectl -n elastic get secret topo-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')')
kubectl -n elastic port-forward service/topo-es-es-http 9201:9200 &
alias es2="curl -sk -u elastic:$PASSWORD https://localhost:9201"
[6] 207479
root@vmi3487682:~# Forwarding from 127.0.0.1:9201 -> 9200
Forwarding from [::1]:9201 -> 9200
^C
root@vmi3487682:~# es2 -X PUT "/loja2?pretty" -H 'Content-Type: application/json' -d '{
  "settings": { "number_of_shards": 2, "number_of_replicas": 1 }
}'
Handling connection for 9201
{"error":"Incorrect HTTP method for uri [/] and method [PUT], allowed: [GET, DELETE, HEAD]","status":405}root@vmi3487682:~curl -sk -u "elastic:$PASSWORD" -X PUT "https://localhost:9201/loja2?pretty" -H 'Content-Type: application/json' -d '{'{
  "settings": { "number_of_shards": 2, "number_of_replicas": 1 }
}'
curl -sk -u "elastic:$PASSWORD" "https://localhost:9201/_cat/shards/loja2?v"
Handling connection for 9201
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "loja2"
}
Handling connection for 9201
index shard prirep state        docs store dataset ip              node
loja2 0     p      STARTED         0  227b    227b 192.168.149.153 topo-es-es-default-1
loja2 0     r      INITIALIZING    0  227b    227b 192.168.149.152 topo-es-es-default-0
loja2 1     p      STARTED         0  227b    227b 192.168.149.152 topo-es-es-default-0
loja2 1     r      UNASSIGNED
root@vmi3487682:~# es2 "/_cat/shards/loja2?v"
Handling connection for 9201
{
  "name" : "topo-es-es-default-0",
  "cluster_name" : "topo-es",
  "cluster_uuid" : "99W0p-wzRnyr1SKutwEQzQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es2 "/_cat/nodes?v&h=name,node.role"      # dois nós
Handling connection for 9201
{
  "name" : "topo-es-es-default-0",
  "cluster_name" : "topo-es",
  "cluster_uuid" : "99W0p-wzRnyr1SKutwEQzQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es2 "/_cat/nodes?v&h=name,node.role"      # dois nós
Handling connection for 9201
{
  "name" : "topo-es-es-default-0",
  "cluster_name" : "topo-es",
  "cluster_uuid" : "99W0p-wzRnyr1SKutwEQzQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es2 "/_cluster/health/loja2?pretty"
Handling connection for 9201
{
  "name" : "topo-es-es-default-0",
  "cluster_name" : "topo-es",
  "cluster_uuid" : "99W0p-wzRnyr1SKutwEQzQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# for i in 1 2 3 4 5; do
  es2 -X POST "/loja2/_doc?refresh=true" -H 'Content-Type: application/json' -d "{\"n\": $i}" >/dev/null
done
Handling connection for 9201
Handling connection for 9201
Handling connection for 9201
Handling connection for 9201
Handling connection for 9201
root@vmi3487682:~# es2 "/_cat/segments/loja2?v&h=shard,prirep,segment,docs.count,docs.deleted,size"
Handling connection for 9201
{
  "name" : "topo-es-es-default-0",
  "cluster_name" : "topo-es",
  "cluster_uuid" : "99W0p-wzRnyr1SKutwEQzQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# es2 -X POST "/loja2/_forcemerge?max_num_segments=1&pretty"
Handling connection for 9201
{"error":"Incorrect HTTP method for uri [/] and method [POST], allowed: [GET, DELETE, HEAD]","status":405}root@vmi3487682:~# curl -sk -u "elastic:$PASSWORD" -X POST "https://localhost:9201/loja2/_forcemerge?max_num_segments=1&pretty"
Handling connection for 9201
{
  "_shards" : {
    "total" : 4,
    "successful" : 4,
    "failed" : 0
  }
}
root@vmi3487682:~# es2 "/_cat/segments/loja2?v&h=shard,prirep,segment,docs.count,docs.deleted"
Handling connection for 9201
{
  "name" : "topo-es-es-default-0",
  "cluster_name" : "topo-es",
  "cluster_uuid" : "99W0p-wzRnyr1SKutwEQzQ",
  "version" : {
    "number" : "9.4.2",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "c402c2b36d90eae29c0182f86bd9050fd0b746cc",
    "build_date" : "2026-05-25T22:10:36.017759931Z",
    "build_snapshot" : false,
    "lucene_version" : "10.4.0",
    "minimum_wire_compatibility_version" : "8.19.0",
    "minimum_index_compatibility_version" : "8.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vmi3487682:~# kubectl -n elastic delete elasticsearch topo-es && kubectl apply -n elastic -f ../02-deploy-elastic-stack-eck/manifests/elasticsearch.yaml
elasticsearch.elasticsearch.k8s.elastic.co "topo-es" deleted
error: the path "../02-deploy-elastic-stack-eck/manifests/elasticsearch.yaml" does not exist
root@vmi3487682:~# kubectl -n elastic delete elasticsearch topo-es --ignore-not-found=true
kubectl apply -n elastic -f manifests/elasticsearch.yaml
elasticsearch.elasticsearch.k8s.elastic.co/lab-es created
root@vmi3487682:~# kubectl apply -n elastic -f manifests/elasticsearch.yaml
elasticsearch.elasticsearch.k8s.elastic.co/lab-es configured
root@vmi3487682:~#