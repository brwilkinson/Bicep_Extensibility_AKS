<<<<<<< HEAD
import {DeploymentT,DeploymentHubT,DeploymentName} from '../bicepT/deployment.bicep'
import {AKSAppDef} from '../bicepT/resources.bicep'

param Deployment DeploymentT
param DeploymentHub DeploymentHubT
param AKSApp AKSAppDef[]
=======
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
>>>>>>> 267f3b63e49833f101389b5016284d5741a50c05


@description('short name for the keyvault e.g. VLT01 or VLT02')
param VaultName string

var DeploymentN = DeploymentName(Deployment)

<<<<<<< HEAD
resource AKS 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' existing = [for (App, index) in AKSApp: {
  name: '${DeploymentN}-aks${App.clusterName}'
=======
// var test = DeploymentHub

var Deployment = '${DeploymentDef.prefix}-${DeploymentDef.orgName}-${DeploymentDef.appName}-${DeploymentDef.Environment}${DeploymentDef.DeploymentId}'

resource AKS 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' existing = [for (App, index) in AKSAppDefs: {
  name: '${Deployment}-aks${App.clusterName}'
>>>>>>> 267f3b63e49833f101389b5016284d5741a50c05
}]

module AKSAppM 'AKSApp.bicep' = [for (App, index) in AKSApp: {
  name: '${DeploymentN}-${App.serviceName}'
  params: {
    AKSApp: App
<<<<<<< HEAD
    DeploymentHub: DeploymentHub
=======
    // DeploymentDef: DeploymentDef
    DeploymentHubDef: DeploymentHub
>>>>>>> 267f3b63e49833f101389b5016284d5741a50c05
    VaultName: VaultName
    kubeConfig: AKS[index].listClusterAdminCredential().kubeconfigs[0].value
  }
}]

output hostname array = [for (App, index) in AKSApp: AKSAppM[index].outputs.hostname ]


