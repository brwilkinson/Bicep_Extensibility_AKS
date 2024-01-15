import {DeploymentT,DeploymentHubT,DeploymentName} from '../bicepT/deployment.bicep'
import {AKSAppDef} from '../bicepT/resources.bicep'

param Deployment DeploymentT
param DeploymentHub DeploymentHubT
param AKSApp AKSAppDef[]

@description('short name for the keyvault e.g. VLT01 or VLT02')
param VaultName string

var DeploymentN = DeploymentName(Deployment)

resource AKS 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' existing = [for (App, index) in AKSApp: {
  name: '${DeploymentN}-aks${App.clusterName}'
}]

module AKSAppM 'AKSApp.bicep' = [for (App, index) in AKSApp: {
  name: '${DeploymentN}-${App.serviceName}'
  params: {
    AKSApp: App
    DeploymentHub: DeploymentHub
    VaultName: VaultName
    kubeConfig: AKS[index].listClusterAdminCredential().kubeconfigs[0].value
  }
}]

output hostname array = [for (App, index) in AKSApp: AKSAppM[index].outputs.hostname ]


