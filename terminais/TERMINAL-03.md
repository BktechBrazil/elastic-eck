root@vmi3487682:~# source _assets/versions.env
PASSWORD=$(kubectl -n elastic get secret lab-es-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
pkill -f "port-forward.*9200" || true
kubectl -n elastic port-forward service/lab-es-es-http 9200 &
sleep 2
[7] 94630
Forwarding from 127.0.0.1:9200 -> 9200
Forwarding from [::1]:9200 -> 9200
[6]-  Terminated              kubectl -n elastic port-forward service/lab-es-es-http 9200