root@vmi3487682:~# source ../_assets/versions.env
-bash: ../_assets/versions.env: No such file or directory
root@vmi3487682:~# kubectl -n elastic get elasticsearch,statefulset,pod,pvc,svc,secret | grep -i quickstart
elasticsearch.elasticsearch.k8s.elastic.co/quickstart   green    1       9.4.2     Ready   21m
statefulset.apps/quickstart-es-default   1/1     21m
pod/quickstart-es-default-0          1/1     Running   0          21m
pod/quickstart-kb-65587bf788-xqrc5   1/1     Running   0          21m
persistentvolumeclaim/elasticsearch-data-quickstart-es-default-0   Bound    pvc-65bfe473-c26f-4470-8cf7-44019c087c37   20Gi       RWO            local-path     <unset>                 21m
service/quickstart-es-default         ClusterIP   None             <none>        9200/TCP   21m
service/quickstart-es-http            ClusterIP   10.106.250.124   <none>        9200/TCP   21m
service/quickstart-es-internal-http   ClusterIP   10.110.160.239   <none>        9200/TCP   21m
service/quickstart-es-transport       ClusterIP   None             <none>        9300/TCP   21m
service/quickstart-kb-http            ClusterIP   10.106.3.34      <none>        5601/TCP   21m
secret/elastic-quickstart-kibana-user             Opaque   2      21m
secret/quickstart-es-default-es-config            Opaque   1      21m
secret/quickstart-es-default-es-transport-certs   Opaque   3      21m
secret/quickstart-es-elastic-user                 Opaque   1      21m
secret/quickstart-es-file-settings                Opaque   1      21m
secret/quickstart-es-http-ca-internal             Opaque   2      21m
secret/quickstart-es-http-certs-internal          Opaque   3      21m
secret/quickstart-es-http-certs-public            Opaque   2      21m
secret/quickstart-es-internal-users               Opaque   5      21m
secret/quickstart-es-remote-ca                    Opaque   1      21m
secret/quickstart-es-transport-ca-internal        Opaque   2      21m
secret/quickstart-es-transport-certs-public       Opaque   1      21m
secret/quickstart-es-xpack-file-realm             Opaque   4      21m
secret/quickstart-kb-config                       Opaque   1      21m
secret/quickstart-kb-es-ca                        Opaque   2      21m
secret/quickstart-kb-http-ca-internal             Opaque   2      21m
secret/quickstart-kb-http-certs-internal          Opaque   3      21m
secret/quickstart-kb-http-certs-public            Opaque   2      21m
secret/quickstart-kibana-user                     Opaque   4      21m
root@vmi3487682:~# kubectl -n elastic describe elasticsearch quickstart | sed -n '/Events/,$p'
kubectl -n elastic get elasticsearch quickstart -o yaml | less
Events:                   <none>
root@vmi3487682:~# kubectl -n elastic delete pod quickstart-es-default-0
kubectl -n elastic get pods -w
pod "quickstart-es-default-0" deleted
^CNAME                             READY   STATUS        RESTARTS   AGE
quickstart-es-default-0          1/1     Terminating   0          22m
quickstart-kb-65587bf788-xqrc5   1/1     Running       0          22m
root@vmi3487682:~# kubectl -n elastic describe elasticsearch quickstart | sed -n '/Events/,$p'
kubectl -n elastic get elasticsearch quickstart -o yaml | less
Events:                   <none>
root@vmi3487682:~# kubectl -n elastic delete pod quickstart-es-default-0
kubectl -n elastic get pods -w
pod "quickstart-es-default-0" deleted
^CNAME                             READY   STATUS        RESTARTS   AGE
quickstart-es-default-0          1/1     Terminating   0          22m
quickstart-kb-65587bf788-xqrc5   1/1     Running       0          22m
quickstart-es-default-0          0/1     Terminating   0          22m
quickstart-es-default-0          0/1     Terminating   0          22m
quickstart-es-default-0          0/1     Error         0          22m
quickstart-es-default-0          0/1     Error         0          22m
quickstart-es-default-0          0/1     Error         0          22m
quickstart-es-default-0          0/1     Pending       0          0s
quickstart-es-default-0          0/1     Pending       0          1s
quickstart-es-default-0          0/1     Init:0/2      0          1s
quickstart-es-default-0          0/1     Init:0/2      0          1s
quickstart-es-default-0          0/1     Init:0/2      0          2s
quickstart-es-default-0          0/1     Init:0/2      0          3s
quickstart-es-default-0          0/1     Init:0/2      0          3s
quickstart-es-default-0          0/1     Init:1/2      0          4s
quickstart-es-default-0          0/1     PodInitializing   0          5s
^Croot@vmi3487682:~# mkdir -p manifests

echo 'apiVersion: elasticsearch.k8s.elastic.co/v1' > manifests/elasticsearch.yaml
echo 'kind: Elasticsearch' >> manifests/elasticsearch.yaml
echo 'metadata:' >> manifests/elasticsearch.yaml
echo '  name: lab-es' >> manifests/elasticsearch.yaml
echo 'spec:' >> manifests/elasticsearch.yaml
echo '  version: 9.4.2' >> manifests/elasticsearch.yaml
echo '  nodeSets:' >> manifests/elasticsearch.yaml
echo '    - name: default' >> manifests/elasticsearch.yaml
echo '      count: 1' >> manifests/elasticsearch.yaml
echo '      config:' >> manifests/elasticsearch.yaml
echo '        node.store.allow_mmap: true' >> manifests/elasticsearch.yaml
echo '      podTemplate:' >> manifests/elasticsearch.yaml
echo '        spec:' >> manifests/elasticsearch.yaml
echo '          containers:' >> manifests/elasticsearch.yaml
echo '            - name: elasticsearch' >> manifests/elasticsearch.yaml
echo '              env:' >> manifests/elasticsearch.yaml
echo '                - name: ES_JAVA_OPTS' >> manifests/elasticsearch.yaml
echo '                  value: -Xms2g -Xmx2g' >> manifests/elasticsearch.yaml
echo '              resources:' >> manifests/elasticsearch.yaml
echo '                requests:' >> manifests/elasticsearch.yaml
echo '                  memory: 4Gi' >> manifests/elasticsearch.yaml
echo '                  cpu: "1"' >> manifests/elasticsearch.yaml
echo '                limits:' >> manifests/elasticsearch.yaml
echo '                  memory: 4Gi' >> manifests/elasticsearch.yaml
echo '      volumeClaimTemplates:' >> manifests/elasticsearch.yaml
echo '        - metadata:' >> manifests/elasticsearch.yaml
echo '            name: elasticsearch-data' >> manifests/elasticsearch.yaml
echo '          spec:' >> manifests/elasticsearch.yaml
echo '            accessModes: [ReadWriteOnce]' >> manifests/elasticsearch.yaml
echo '            resources:' >> manifests/elasticsearch.yaml
echo '              requests:' >> manifests/elasticsearch.yaml
echo '                storage: 20Gi' >> manifests/elasticsearch.yaml
echo '            storageClassName: local-path' >> manifests/elasticsearch.yaml

echo 'apiVersion: kibana.k8s.elastic.co/v1' > manifests/kibana.yaml
echo 'kind: Kibana' >> manifests/kibana.yaml
echo 'metadata:' >> manifests/kibana.yaml
echo '  name: lab-kb' >> manifests/kibana.yaml
echo 'spec:' >> manifests/kibana.yaml
echo '  version: 9.4.2' >> manifests/kibana.yaml
echo '  count: 1' >> manifests/kibana.yaml
echo '  elasticsearchRef:' >> manifests/kibana.yaml
echo '    name: lab-es' >> manifests/kibana.yaml
echo '  podTemplate:' >> manifests/kibana.yaml
echo '              memory: 2Gi' >> manifests/kibana.yaml
root@vmi3487682:~# kubectl apply -n elastic -f manifests/elasticsearch.yaml
kubectl apply -n elastic -f manifests/kibana.yaml
kubectl -n elastic get pods -w
elasticsearch.elasticsearch.k8s.elastic.co/lab-es created
kibana.kibana.k8s.elastic.co/lab-kb created
NAME                             READY   STATUS    RESTARTS   AGE
quickstart-es-default-0          1/1     Running   0          9m45s
quickstart-kb-65587bf788-xqrc5   1/1     Running   0          32m
lab-es-es-default-0              0/1     Pending   0          0s
lab-kb-kb-5cc5cc5ff8-hpwv4       0/1     Pending   0          0s
lab-kb-kb-5cc5cc5ff8-hpwv4       0/1     Pending   0          0s
lab-kb-kb-5cc5cc5ff8-hpwv4       0/1     Init:0/1   0          0s
lab-kb-kb-5cc5cc5ff8-hpwv4       0/1     Init:0/1   0          1s
lab-kb-kb-5cc5cc5ff8-hpwv4       0/1     Init:0/1   0          2s
lab-kb-kb-5cc5cc5ff8-hpwv4       0/1     PodInitializing   0          3s
lab-kb-kb-5cc5cc5ff8-hpwv4       0/1     Running           0          4s
lab-es-es-default-0              0/1     Pending           0          5s
lab-es-es-default-0              0/1     Init:0/2          0          5s
lab-es-es-default-0              0/1     Init:0/2          0          6s
lab-es-es-default-0              0/1     Init:0/2          0          8s
lab-es-es-default-0              0/1     Init:0/2          0          8s
lab-es-es-default-0              0/1     Init:0/2          0          8s
lab-es-es-default-0              0/1     Init:1/2          0          10s
lab-es-es-default-0              0/1     PodInitializing   0          11s
lab-es-es-default-0              0/1     Running           0          12s
^Croot@vmi3487682:~PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user \ \
  -o go-template='{{.data.elastic | base64decode}}')
echo "Senha: $PASSWORD"
Senha: oKH0OxYgERRBMVeIyCCOofBC
root@vmi3487682:~# kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cluster/health?pretty
[3] 43712
Unable to listen on port 9200: Listeners failed to create with the following errors: [unable to create listener: Error listen tcp4 127.0.0.1:9200: bind: address already in use unable to create listener: Error listen tcp6 [::1]:9200: bind: address already in use]
error: unable to listen on any of the requested ports: [{9200 9200}]
[3]+  Exit 1                  kubectl -n elastic port-forward service/lab-es-es-http 9200
Handling connection for 9200
E0807 15:25:27.073424   29893 portforward.go:413] "Unhandled Error" err="an error occurred forwarding 9200 -> 9200: error forwarding port 9200 to pod 42f8c4d9459a3bee34d13bb482a57bd03ed898b4a712f5f349512f19ea33c963, uid : failed to find sandbox \"42f8c4d9459a3bee34d13bb482a57bd03ed898b4a712f5f349512f19ea33c963\" in store: not found"
error: lost connection to pod
curl: (35) error:0A000126:SSL routines::unexpected eof while reading
[1]-  Exit 1                  kubectl -n ${LAB_NAMESPACE} port-forward service/quickstart-es-http 9200
root@vmi3487682:~# pkill -f "port-forward" || true

kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cluster/health?pretty
[3] 52019
Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
[2]-  Terminated              kubectl -n ${LAB_NAMESPACE} port-forward --address 0.0.0.0 service/quickstart-kb-http 5601
Handling connection for 9200
{
  "cluster_name" : "lab-es",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 43,
  "active_shards" : 43,
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
root@vmi3487682:~# kubectl -n elastic get secret lab-es-es-http-certs-public \
  -o go-template='{{index .data "ca.crt" | base64decode}}' > ca.crt
curl --cacert ca.crt -u "elastic:$PASSWORD" https://localhost:9200
Handling connection for 9200
curl: (60) SSL: no alternative certificate subject name matches target host name 'localhost'
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
root@vmi3487682:~# openssl x509 -in ca.crt -noout -text | grep -A1 "Subject Alternative"
>
> # Use --resolve para que o curl resolva o hostname do cert para localhost:
> curl --cacert ca.crt \
>   --resolve "lab-es-es-http.elastic.svc:9200:127.0.0.1" \
>   -u "elastic:$PASSWORD" \
>   https://lab-es-es-http.elastic.svc:9200
-bash: syntax error near unexpected token `newline'
-bash: syntax error near unexpected token `newline'
-bash: https://lab-es-es-http.elastic.svc:9200: No such file or directory
root@vmi3487682:~# kubectl -n elastic get secret lab-es-es-http-certs-public -o go-template='{{index .data "ca.crt" | base64decode}}' > ca.crt
kubectl -n elastic get secret lab-es-es-http-certs-public -o go-template='{{index .data "tls.crt" | base64decode}}' > tls.crt
root@vmi3487682:~# openssl x509 -in tls.crt -noout -text | grep -A5 "Subject Alternative"
            X509v3 Subject Alternative Name:
                DNS:lab-es-es-http.elastic.es.local, DNS:lab-es-es-http, DNS:lab-es-es-http.elastic.svc, DNS:lab-es-es-http.elastic, DNS:lab-es-es-internal-http.elastic.svc, DNS:lab-es-es-internal-http.elastic, DNS:*.lab-es-es-default.elastic.svc
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        4d:af:4b:d7:67:80:9a:24:25:89:8d:cc:04:f9:f7:a7:cd:5d:
        63:0b:d0:00:87:88:75:b4:ce:96:37:6f:7d:ca:f6:36:e0:68:
root@vmi3487682:~# curl --cacert ca.crt --resolve "lab-es-es-http.elastic.svc:9200:127.0.0.1" -u "elastic:$PASSWORD" https://lab-es-es-http.elastic.svc:9200
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
root@vmi3487682:~# pkill -f "port-forward.*5601" || true
kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-http 5601 &
[4] 57732
root@vmi3487682:~# Error from server (NotFound): services "lab-kb-http" not found
root@vmi3487682:~# pkill -f "port-forward.*5601" || true
kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-http 5601 &
[4]+  Exit 1                  kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-http 5601
[4] 65618
root@vmi3487682:~# Error from server (NotFound): services "lab-kb-http" not found
root@vmi3487682:~# kubectl -n elastic get svc
kubectl -n elastic get kibana
NAME                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
lab-es-es-default             ClusterIP   None             <none>        9200/TCP   37m
lab-es-es-http                ClusterIP   10.104.22.182    <none>        9200/TCP   37m
lab-es-es-internal-http       ClusterIP   10.96.184.26     <none>        9200/TCP   37m
lab-es-es-transport           ClusterIP   None             <none>        9300/TCP   37m
lab-kb-kb-http                ClusterIP   10.103.196.68    <none>        5601/TCP   37m
quickstart-es-default         ClusterIP   None             <none>        9200/TCP   69m
quickstart-es-http            ClusterIP   10.106.250.124   <none>        9200/TCP   69m
quickstart-es-internal-http   ClusterIP   10.110.160.239   <none>        9200/TCP   69m
quickstart-es-transport       ClusterIP   None             <none>        9300/TCP   69m
quickstart-kb-http            ClusterIP   10.106.3.34      <none>        5601/TCP   69m
[4]+  Exit 1                  kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-http 5601
NAME         HEALTH   NODES   VERSION   AGE
lab-kb       green    1       9.4.2     37m
quickstart   green    1       9.4.2     69m
root@vmi3487682:~# pkill -f "port-forward.*5601" || true
kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-kb-http 5601 &
[4] 67033
root@vmi3487682:~# Forwarding from 0.0.0.0:5601 -> 5601
Handling connection for 5601
Handling connection for 5601
^C
root@vmi3487682:~# curl -k -u "elastic:$PASSWORD" "https://localhost:9200/_cat/indices?v" | grep kibana_sample
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Handling connection for 9200
100   468    0   468    0     0   2636      0 --:--:-- --:--:-- --:--:--  2644
root@vmi3487682:~# kubectl -n elastic get elasticsearch lab-es          # HEALTH green
kubectl -n elastic get kibana lab-kb                 # HEALTH green
curl -k -u "elastic:$PASSWORD" https://localhost:9200/_cat/indices?v | grep sample
NAME     HEALTH   NODES   VERSION   PHASE   AGE
lab-es   green    1       9.4.2     Ready   38m
NAME     HEALTH   NODES   VERSION   AGE
lab-kb   green    1       9.4.2     38m
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Handling connection for 9200
100   468    0   468    0     0   6911      0 --:--:-- --:--:-- --:--:--  6985