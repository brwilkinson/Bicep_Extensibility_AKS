@secure()
param kubeConfig string
param nameSpace string
param name string
param image string

import 'kubernetes@1.0.0' with {
  namespace: nameSpace
  kubeConfig: kubeConfig
}

resource appsDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: name
    namespace: nameSpace
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: name
      }
    }
    template: {
      metadata: {
        labels: {
          app: name
        }
      }
      spec: {
        containers: [
          {
            name: name
            image: image
            ports: [
              {
                containerPort: 80
              }
            ]
            env: [
              {
                name: 'TITLE'
                value: 'Welcome to Azure Kubernetes Service (AKS)'
              }
            ]
          }
        ]
      }
    }
  }
}
