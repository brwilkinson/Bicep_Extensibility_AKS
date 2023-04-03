##### This is a repo for setting up AKS Namespaces for onboarding in Kubernetes

###### Goal
- Migrate an Helm Chart to Bicep format to test Bicep extensibility
- Use the Bicepparams experimentatal feature for params, that would replace the values.yaml from Helm 

###### Docs

[Bicep Extensibility - Experminental Feature](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config#enable-experimental-features)

[Define Application in Bicep](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-bicep-extensibility-kubernetes-provider?tabs=PowerShell%2Cazure-powershell#add-the-application-definition)

[AKS Ingress - Web Application Routing](https://learn.microsoft.com/en-us/azure/aks/web-app-routing?tabs=with-osm)

###### Bicep Extensibility uses `import`

```bicep
@secure()
param kubeConfig string

import 'kubernetes@1.0.0' with {
  namespace: 'default'
  kubeConfig: kubeConfig
}

```