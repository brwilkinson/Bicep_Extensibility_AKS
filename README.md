##### This is a repo for setting up AKS Namespaces for onboarding in Kubernetes

###### Goal
- Migrate an Helm Chart to Bicep format to test Bicep extensibility
- Use the Bicepparams experimentatal feature for params, that would replace the values.yaml from Helm 

###### Docs

[Bicep Extensibility - Experminental Feature](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config#enable-experimental-features)

[Define Application in Bicep](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-bicep-extensibility-kubernetes-provider?tabs=PowerShell%2Cazure-powershell#add-the-application-definition)

[AKS Ingress - Web Application Routing](https://learn.microsoft.com/en-us/azure/aks/web-app-routing?tabs=with-osm)

#### bicepconfi.json for preview features
```json
{
  "experimentalFeaturesEnabled": {
    "paramsFiles": true,
    "extensibility": true
  }
}
```

###### Bicep Extensibility uses `import`

- Example to create namespace

```bicep
@secure()
param kubeConfig string
param nameSpace string

import 'kubernetes@1.0.0' with {
  namespace: 'default'
  kubeConfig: kubeConfig
}

resource coreNamespace 'core/Namespace@v1' = {
  metadata: {
    name: nameSpace
  }
}
```
- Example using bicepparam

```bicep
using '../../bicep/main.bicep'

param prefix = 'AEU1'
param orgName = 'PE'
param appName = 'CTL'
param Environment = 'D'
param DeploymentId = '1'
param ClusterName = '01'
param VaultName = 'VLT01'

param nameSpace= 'hello-web-app-routing'
param serviceName= 'aks-helloworld2'
param image= 'mcr.microsoft.com/azuredocs/aks-helloworld:v1'
param customDomain= 'psthing.com'
param titleMessage= '''
"Web App Routing ingress" --> Deployed with Azure Bicep
'''
```
- Example for compiling bicepparam and deploying main.bicep

```powershell
$Base = $PSScriptRoot
$ParamsBase = "$Base\tenants\LAB\values-d1"
$splat = @{
    Name                  = 'Namespace_Bicep'
    ResourceGroupName     = 'AEU1-PE-CTL-RG-D1'
    TemplateFile          = "$Base\bicep\main.bicep"
    TemplateParameterFile = "${ParamsBase}.json" # bicepparam compilation not supported as yet
}

# test out biep params, manually build
bicep build-params "${ParamsBase}.bicepparam"
New-AzResourceGroupDeployment @splat -Verbose
```