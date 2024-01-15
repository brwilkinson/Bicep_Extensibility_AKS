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

param secretName string
param hubRG string
param hubDeployment string
param VaultName string
param hostname string

provider 'kubernetes@1.0.0' with {
  namespace: AKSApp.nameSpace
  kubeConfig: kubeConfig
}


resource KV 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: '${hubDeployment}-kv${VaultName}'
  scope: resourceGroup(hubRG)

  resource mySecret 'secrets' existing = {
    name: AKSApp.serviceName
  }
}

resource networkingK8sIoIngress 'networking.k8s.io/Ingress@v1' = {
  metadata: {
    annotations: {
      'kubernetes.azure.com/tls-cert-keyvault-uri': KV::mySecret.properties.secretUri
    }
    name: AKSApp.serviceName
    namespace: AKSApp.nameSpace
  }
  spec: {
    ingressClassName: 'webapprouting.kubernetes.azure.com'
    rules: [
      {
        host: hostname
        http: {
          paths: [
            {
              backend: {
                service: {
                  name: AKSApp.serviceName
                  port: {
                    number: 80
                  }
                }
              }
              path: '/'
              pathType: 'Prefix'
            }
          ]
        }
      }
    ]
    tls: [
      {
        hosts: [
          hostname
        ]
        secretName: secretName
      }
    ]
  }
}
