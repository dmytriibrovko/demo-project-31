Get password for elastic
PASSWORD=$(k get secret -n logging demo-project-31-es-elastic-user -o=jsonpath='{ .data.elastic}' |base64 --decode)
echo $PASSWORD

Logging 
k port-forward -n logging svc/demo-project-31-es-http 9200 &
curl -u "elastic:$PASSWORD" -k localhost:9200

Kibana
k port-forward -n logging svc/kibana-kb-http 5601&
