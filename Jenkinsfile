pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
  name: elk
spec:
  containers:
  - name: dnd
    image: docker:latest
    command: 
    - cat
    tty: true
    volumeMounts: 
    - mountPath: /var/run/docker.sock
      name: docker-sock
  - name: kubectl
    image: bryandollery/terraform-packer-aws-alpine
    command:
    - cat
    tty: true
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock  
      type: Socket
"""
    }
  }
  environment {
    TOKEN=credentials('5d7560ab-096d-44cb-bcc5-34c620a38a51')
}
  stages {
      stage("Deploy") {
          steps {
              container('kubectl') {
                  sh '''
                    #kubectl --token=$TOKEN create clusterrolebinding grafana --clusterrole cluster-admin --serviceaccount=jenkins:jenkins -n monitor
                    #. pro-graf.sh
                    #kubectl --token=$TOKEN -n monitor create namespace monitor
                    helm repo add stable https://kubernetes-charts.storage.googleapis.com
		    helm repo update
                    helm install prometheus-operator stable/prometheus-operator --namespace monitor --set grafana.service.type=NodePort --set prometheus.service.type=NodePort
                    kubectl apply -f ingress.yaml -n monitor
                    kubectl --token=$TOKEN -n monitor get all
                    sleep 60
                    echo "grafana Port"
                    kubectl --token=$TOKEN get service prometheus-operator-grafana -n monitor -o json | jq '.spec.ports[0].nodePort' 
                  '''
              }
          }
      }
  }
}
