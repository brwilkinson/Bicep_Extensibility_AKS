@secure()
param kubeConfig string

param AKSApp AKSAppDef

type AKSAppDef = {
  @description('The object to define the Deployment')
  nameSpace: string
  serviceName: string
  image: string
  customDomain: string
  titleMessage: string
  clusterName: string
}

provider 'kubernetes@1.0.0' with {
  namespace: AKSApp.nameSpace
  kubeConfig: kubeConfig
}

resource appsDeployment 'apps/Deployment@v1' = {
  metadata: {
    name: AKSApp.serviceName
    namespace: AKSApp.nameSpace
  }
  spec: {
    replicas: 1
    selector: {
      matchLabels: {
        app: AKSApp.serviceName
      }
    }
    template: {
      metadata: {
        labels: {
          app: AKSApp.serviceName
        }
      }
      spec: {
        containers: [
          {
            name: AKSApp.serviceName
            image: AKSApp.image
            ports: [
              {
                containerPort: 80
              }
            ]
            env: [
              {
                name: 'TITLE'
                value: AKSApp.titleMessage
              }
            ]
          }
        ]
      }
    }
  }
}
