param DeploymentHub DeploymentHubType
param DeploymentDef DeploymentDefType
param AKSAppDefs AKSAppType[]

type DeploymentHubType = {
  @description('The object to define the Hub Deployment')
  prefix: string
  orgName: string
  appName: string
}

type DeploymentDefType = {
  @description('The object to define the Deployment')
  prefix: string
  orgName: string
  appName: string
  Environment: string
  DeploymentId: string
}

type AKSAppType = {
  @description('The object to define the Deployment')
  nameSpace: string
  serviceName: string
  image: string
  customDomain: string
  titleMessage: string
  clusterName: string
  tlsCertName: string
}


@description('short name for the keyvault e.g. VLT01 or VLT02')
param VaultName string

// @description('test loadjsoncontent()')
// param Global object

// var test = DeploymentHub

var Deployment = '${DeploymentDef.prefix}-${DeploymentDef.orgName}-${DeploymentDef.appName}-${DeploymentDef.Environment}${DeploymentDef.DeploymentId}'

resource AKS 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' existing = [for (App, index) in AKSAppDefs: {
  name: '${Deployment}-aks${App.clusterName}'
}]

module AKSApp 'AKSApp.bicep' = [for (App, index) in AKSAppDefs: {
  name: '${Deployment}-${App.serviceName}'
  params: {
    AKSApp: App
    // DeploymentDef: DeploymentDef
    DeploymentHubDef: DeploymentHub
    VaultName: VaultName
    kubeConfig: AKS[index].listClusterAdminCredential().kubeconfigs[0].value
  }
}]

output hostname array = [for (App, index) in AKSAppDefs: AKSApp[index].outputs.hostname ]


