@secure()
param kubeConfig string
param nameSpace string
param servicename string

import 'kubernetes@1.0.0' with {
  namespace: nameSpace
  kubeConfig: kubeConfig
}

resource coreService 'core/Service@v1' = {
  metadata: {
    name: servicename
    namespace: nameSpace
  }
  spec: {
    type: 'ClusterIP'
    ports: [
      {
        port: 80
      }
    ]
    selector: {
      app: servicename
    }
  }
}
