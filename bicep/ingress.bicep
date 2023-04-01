@secure()
param kubeConfig string
param nameSpace string
param name string
param hostname string
param KeyVaultCertificateUri string
param secretName string

import 'kubernetes@1.0.0' with {
  namespace: nameSpace
  kubeConfig: kubeConfig
}

resource networkingK8sIoIngress 'networking.k8s.io/Ingress@v1' = {
  metadata: {
    annotations: {
      'kubernetes.azure.com/tls-cert-keyvault-uri': KeyVaultCertificateUri
    }
    name: name
    namespace: nameSpace
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
                  name: name
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
