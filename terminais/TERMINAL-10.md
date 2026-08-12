root@eck-lab:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
alias es="curl -sk -u elastic:$PASSWORD https://localhost:9200"
[3] 2776114
root@eck-lab:~# Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
^C
root@eck-lab:~# es "/?pretty" | grep number      # "number" : "9.4.2"
Handling connection for 9200
    "number" : "9.4.2",
root@eck-lab:~# kubectl apply -n elastic -f manifests/elasticsearch-9.4.4.yaml
error: the path "manifests/elasticsearch-9.4.4.yaml" does not exist
root@eck-lab:~# mkdir -p manifests
cat << 'EOF' > manifests/elasticsearch-9.4.4.yaml
# lab-es atualizado para 9.4.4 (Módulo 10). Idêntico ao do Módulo 02,
# apenas com spec.version alterado. Aplique e o operator faz o rolling upgrade.
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: lab-es
spec:
  version: 9.4.4          # <-- era 9.4.2
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
                requests: { memory: 4Gi, cpu: "1" }
                limits:   { memory: 4Gi }
      volumeClaimTemplates:
        - metadata: { name: elasticsearch-data }
          spec:
            accessModes: [ReadWriteOnce]
            resources: { requests: { storage: 20Gi } }
            storageClassName: local-path
EOF

kubectl apply -n elastic -f manifests/elasticsearch-9.4.4.yaml
kubectl -n elastic get pods -l elasticsearch.k8s.elastic.co/cluster-name=lab-es -w
elasticsearch.elasticsearch.k8s.elastic.co/lab-es configured
NAME                  READY   STATUS    RESTARTS   AGE
lab-es-es-default-0   1/1     Running   0          2d20h
^Croot@eck-lab:~kubectl apply -n elastic -f manifests/elasticsearch-9.4.4.yamlml
elasticsearch.elasticsearch.k8s.elastic.co/lab-es configured
root@eck-lab:~# kubectl -n elastic get pods -l elasticsearch.k8s.elastic.co/cluster-name=lab-es -w
NAME                  READY   STATUS        RESTARTS   AGE
lab-es-es-default-0   1/1     Terminating   0          2d20h
^Croot@eck-lab:~kubectl -n elastic get elasticsearch lab-es      # HEALTH volta a green após a trocaca
NAME     HEALTH   NODES   VERSION   PHASE             AGE
lab-es   yellow           9.4.2     ApplyingChanges   2d20h
root@eck-lab:~# es "/?pretty" | grep number      # agora "9.4.4"
Handling connection for 9200
    "number" : "9.4.2",
root@eck-lab:~# kubectl -n elastic get pods -l elasticsearch.k8s.elastic.co/cluster-name=lab-es -w
NAME                  READY   STATUS     RESTARTS   AGE
lab-es-es-default-0   0/1     Init:0/2   0          11s
lab-es-es-default-0   0/1     Init:0/2   0          38s
lab-es-es-default-0   0/1     Init:0/2   0          38s
lab-es-es-default-0   0/1     Init:0/2   0          38s
lab-es-es-default-0   0/1     Init:1/2   0          42s
lab-es-es-default-0   0/1     PodInitializing   0          43s
lab-es-es-default-0   0/1     Running           0          44s
^Croot@eck-lab:~es "/?pretty" | grep numberer
Handling connection for 9200
E0810 16:05:37.491948 2776114 portforward.go:413] "Unhandled Error" err="an error occurred forwarding 9200 -> 9200: error forwarding port 9200 to pod f49630d9a83c7862ba9415677337962ed10cb9123f104e1610b317deedfbe358, uid : failed to find sandbox \"f49630d9a83c7862ba9415677337962ed10cb9123f104e1610b317deedfbe358\" in store: not found"
error: lost connection to pod
root@eck-lab:~# es "/?pretty" | grep number
[3]+  Exit 1                  kubectl -n elastic port-forward service/lab-es-es-http 9200
root@eck-lab:~# kubectl -n elastic port-forward service/lab-es-es-http 9200
Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
^[[A^[[A^[[A^[[Aes "/?pretty" | grep number
root@eck-lab:~# es "/?pretty" | grep number
root@eck-lab:~# ^C
root@eck-lab:~# # Inicia o port-forward em background e valida a versão
kubectl -n elastic port-forward service/lab-es-es-http 9200 > /dev/null 2>&1 &
es "/?pretty" | grep number
[3] 2782265
root@eck-lab:~# cat << 'EOF' > manifests/kibana-9.4.4.yaml
# lab-kb atualizado para 9.4.4 (Módulo 10). Aplique DEPOIS do Elasticsearch.
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: lab-kb
spec:
  version: 9.4.4          # <-- era 9.4.2 (nunca mais novo que o ES)
  count: 1
  elasticsearchRef:
    name: lab-es
  podTemplate:
    spec:
      containers:
        - name: kibana
          resources:
            requests: { memory: 1Gi, cpu: 500m }
            limits:   { memory: 2Gi }
EOF
root@eck-lab:~# kubectl apply -n elastic -f manifests/kibana-9.4.4.yaml
kibana.kibana.k8s.elastic.co/lab-kb configured
root@eck-lab:~# kubectl -n elastic get kibana lab-kb -w
NAME     HEALTH   NODES   VERSION   AGE
lab-kb   red              9.4.2     3d
lab-kb   red              9.4.4     3d
lab-kb   red              9.4.4     3d
^Croot@eck-lab:~kubectl -n elastic get pods -l kibana.k8s.elastic.co/name=lab-kb -w-w
NAME                         READY   STATUS     RESTARTS   AGE
lab-kb-kb-54f5f65846-7cr2k   0/1     Init:0/1   0          8s
lab-kb-kb-54f5f65846-7cr2k   0/1     Init:0/1   0          52s
lab-kb-kb-54f5f65846-7cr2k   0/1     PodInitializing   0          53s
lab-kb-kb-54f5f65846-7cr2k   0/1     Running           0          54s
lab-kb-kb-54f5f65846-7cr2k   1/1     Running           0          112s
Handling connection for 5601
E0810 16:14:24.055087 2656298 portforward.go:413] "Unhandled Error" err="an error occurred forwarding 5601 -> 5601: error forwarding port 5601 to pod 526887ac9b5662e8a881f77b88e53d9cb415671ed82442a90b81d8cc7d76bc82, uid : failed to find sandbox \"526887ac9b5662e8a881f77b88e53d9cb415671ed82442a90b81d8cc7d76bc82\" in store: not found"
error: lost connection to pod
^C[2]-  Exit 1                  kubectl -n elastic port-forward --address 0.0.0.0 service/lab-kb-kb-http 5601:5601
root@eck-lab:~# kubectl -n elastic get kibana lab-kb
NAME     HEALTH   NODES   VERSION   AGE
lab-kb   green    1       9.4.4     3d
root@eck-lab:~# es "/?pretty" | grep number      # agora "9.4.4"
    "number" : "9.4.4",
root@eck-lab:~#
root@eck-lab:~# kubectl apply -n elastic -f manifests/kibana-9.4.4.yaml
kubectl -n elastic get kibana lab-kb -w          # aguarde green
kibana.kibana.k8s.elastic.co/lab-kb unchanged
NAME     HEALTH   NODES   VERSION   AGE
lab-kb   green    1       9.4.4     3d1h
^Croot@eck-lab:~helm repo updatete
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "elastic" chart repository
Update Complete. ⎈Happy Helming!⎈
root@eck-lab:~# helm search repo elastic/eck-operator --versions | head
NAME                            CHART VERSION   APP VERSION     DESCRIPTION
elastic/eck-operator            3.5.0           3.5.0           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.4.1           3.4.1           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.4.0           3.4.0           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.3.2           3.3.2           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.3.1           3.3.1           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.3.0           3.3.0           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.2.0           3.2.0           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.1.0           3.1.0           Elastic Cloud on Kubernetes (ECK) operator
elastic/eck-operator            3.0.0           3.0.0           Elastic Cloud on Kubernetes (ECK) operator