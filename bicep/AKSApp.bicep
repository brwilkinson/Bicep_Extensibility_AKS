import {DeploymentT,DeploymentHubT,DeploymentName,DeploymentHubName,DeploymentHubRGName} from '../bicepT/deployment.bicep'
import {AKSAppDef} from '../bicepT/resources.bicep'

param DeploymentHub DeploymentHubT

param AKSApp AKSAppDef

@description('short name for the keyvault e.g. VLT01 or VLT02')
param VaultName string

@secure()
param kubeConfig string

var hubDeployment = DeploymentHubName(DeploymentHub)
var hubRG = DeploymentHubRGName(DeploymentHub)

var hostname = '${AKSApp.serviceName}.${AKSApp.customDomain}'
var secretName = 'keyvault-${hostname}' // This is a required name format

resource KV 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: '${hubDeployment}-kv${VaultName}'
  scope: resourceGroup(hubRG)

  resource mySecret 'secrets' existing = {
    name: secretName
  }
}

provider 'kubernetes@1.0.0' with {
  namespace: 'default'
  kubeConfig: kubeConfig
}

resource coreNamespace 'core/Namespace@v1' = {
  metadata: {
    name: AKSApp.nameSpace
  }
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
  dependsOn: [
    coreNamespace
  ]
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
  dependsOn: [
    coreNamespace
  ]
}

resource networkingK8sIoIngress 'networking.k8s.io/Ingress@v1' = {
  metadata: {
    annotations: {
      'kubernetes.azure.com/tls-cert-keyvault-uri': KV::mySecret.properties.secretUri
    }
    name: hostname
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


output hostname string= hostname


