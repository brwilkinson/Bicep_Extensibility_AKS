##### This is a repo for setting up AKS Namespaces for onboarding in Kubernetes

###### Goal
- Migrate an Helm Chart to Bicep format to test Bicep extensibility
- Use the Bicepparams experimentatal feature for params, that would replace the values.yaml from Helm 

###### Docs

[Bicep Extensibility - Experminental Feature](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config#enable-experimental-features)

[Define Application in Bicep](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-bicep-extensibility-kubernetes-provider?tabs=PowerShell%2Cazure-powershell#add-the-application-definition)

[AKS Ingress - Web Application Routing](https://learn.microsoft.com/en-us/azure/aks/web-app-routing?tabs=with-osm)

#### bicepconfig.json for preview features
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
###### Example using bicepparam (replaces json format)

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
param serviceName= 'aks-helloworld'
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

# test out bicep params, manually build
bicep build-params "${ParamsBase}.bicepparam"
New-AzResourceGroupDeployment @splat -Verbose
```

### Execute deployment...

```powershell
pwsh> . .\Bicep_Extensibility_AKS\setup_deploy.ps1

WARNING: Symbolic name support in ARM is experimental, and should be enabled for testing purposes only. Do not enable this setting for any production usage, or you may be unexpectedly broken at any time!
VERBOSE: Using Bicep v0.15.152
WARNING: WARNING: Symbolic name support in ARM is experimental, and should be enabled for testing purposes only. Do not enable this setting for any production usage, or you may be unexpectedly broken at any time!
VERBOSE: Performing the operation "Creating Deployment" on target "AEU1-PE-CTL-RG-D1".
VERBOSE: 9:35:36 PM - Template is valid.
VERBOSE: 9:35:37 PM - Create template deployment 'Namespace_Bicep'
VERBOSE: 9:35:37 PM - Checking deployment status in 5 seconds
VERBOSE: 9:35:43 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-namespace' provisioning status is running
VERBOSE: 9:35:43 PM - Resource  '' provisioning status is succeeded
VERBOSE: 9:35:43 PM - Resource Microsoft.ContainerService/managedClusters 'AEU1-PE-CTL-D1-aks01' provisioning status is succeededVERBOSE: 9:35:43 PM - Resource Microsoft.ContainerService/managedClusters 'AEU1-PE-CTL-D1-aks01' provisioning status is succeeded
VERBOSE: 9:35:43 PM - Resource Microsoft.KeyVault/vaults/secrets 'AEU1-PE-CTL-P0-kvVLT01/aks-helloworld' provisioning status is succeeded
VERBOSE: 9:35:43 PM - Resource Microsoft.KeyVault/vaults 'AEU1-PE-CTL-P0-kvVLT01' provisioning status is succeededVERBOSE: 9:35:43 PM - Checking deployment status in 13 seconds
VERBOSE: 9:35:59 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-deployment' provisioning status is running
VERBOSE: 9:35:59 PM - Resource  '' provisioning status is succeeded
VERBOSE: 9:35:59 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-ingress' provisioning status is running
VERBOSE: 9:35:59 PM - Resource  '' provisioning status is succeeded
VERBOSE: 9:35:59 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-service' provisioning status is running
VERBOSE: 9:35:59 PM - Resource  '' provisioning status is succeeded
VERBOSE: 9:35:59 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-namespace' provisioning status is succeeded
VERBOSE: 9:35:59 PM - Checking deployment status in 14 seconds
VERBOSE: 9:36:15 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-deployment' provisioning status is succeeded
VERBOSE: 9:36:15 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-ingress' provisioning status is succeeded
VERBOSE: 9:36:15 PM - Resource Microsoft.Resources/deployments 'aks-helloworld-service' provisioning status is succeeded

DeploymentName          : Namespace_Bicep
ResourceGroupName       : AEU1-PE-CTL-RG-D1
ProvisioningState       : Succeeded
Timestamp               : 4/4/2023 4:36:11 AM
Mode                    : Incremental
TemplateLink            : 
Parameters              : 
                          Name             Type                       Value     
                          ===============  =========================  ==========
                          nameSpace        String                     "hello-web-app-routing"
                          serviceName      String                     "aks-helloworld"
                          image            String                     "mcr.microsoft.com/azuredocs/aks-helloworld:v1"
                          customDomain     String                     "psthing.com"
                          prefix           String                     "AEU1"
                          orgName          String                     "PE"
                          appName          String                     "CTL"
                          environment      String                     "D"
                          deploymentId     String                     "1"
                          clusterName      String                     "01"
                          vaultName        String                     "VLT01"
                          titleMessage     String                     "\"Web App Routing ingress\" --> Deployed with Azure Bicep\r\n"

Outputs                 : 
                          Name             Type                       Value
                          ===============  =========================  ==========
                          hostname         String                     "https://aks-helloworld.psthing.com"

```

![Deployed](./docs/deployed_image.png)