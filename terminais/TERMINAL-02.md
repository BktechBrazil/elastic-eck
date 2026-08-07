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
