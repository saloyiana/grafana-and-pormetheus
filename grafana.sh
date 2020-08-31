#!bin/bash
POD=$(kubectl get pods -n monitor -o json | jq '.items[1].metadata.name' | xargs)
echo "grafana Port"
echo port: $(kubectl get service prometheus-operator-grafana -n monitor -o json | jq '.spec.ports[0].nodePort')
