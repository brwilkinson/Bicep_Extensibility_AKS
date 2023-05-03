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

import 'kubernetes@1.0.0' with {
  namespace: AKSApp.nameSpace
  kubeConfig: kubeConfig
}

resource coreService 'core/Service@v1' = {
  metadata: {
    name: AKSApp.serviceName
    namespace: AKSApp.nameSpace
  }
  spec: {
    type: 'ClusterIP'
    ports: [
      {
        port: 80
      }
    ]
    selector: {
      app: AKSApp.serviceName
    }
  }
}
