param DeploymentDef {
  @description('The object to define the Deployment')
  prefix: string
  orgName: string
  appName: string
  Environment: string
  DeploymentId: string
}

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

@description('short name for the keyvault e.g. VLT01 or VLT02')
param VaultName string


var Deployment = '${DeploymentDef.prefix}-${DeploymentDef.orgName}-${DeploymentDef.appName}-${DeploymentDef.Environment}${DeploymentDef.DeploymentId}'
var hubDeployment = '${DeploymentDef.prefix}-${DeploymentDef.orgName}-${DeploymentDef.appName}-P0'
var hubRG = '${DeploymentDef.prefix}-${DeploymentDef.orgName}-${DeploymentDef.appName}-RG-P0'

resource AKS 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' existing = {
  name: '${Deployment}-aks${AKSApp.clusterName}'
}

module namespace 'namespace.bicep' = {
  name: '${AKSApp.serviceName}-namespace'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    AKSApp: AKSApp
  }
}

module deployment 'deployment.bicep' = {
  name: '${AKSApp.serviceName}-deployment'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    AKSApp: AKSApp
  }
  dependsOn: [
    namespace
  ]
}

module service 'service.bicep' = {
  name: '${AKSApp.serviceName}-service'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    AKSApp: AKSApp
  }
  dependsOn: [
    namespace
  ]
}

module ingress 'ingress.bicep' = {
  name: '${AKSApp.serviceName}-ingress'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    AKSApp: AKSApp
    hostname: '${AKSApp.serviceName}.${AKSApp.customDomain}'
    secretName: AKSApp.serviceName
    hubDeployment: hubDeployment
    hubRG: hubRG
    VaultName: VaultName
  }
  dependsOn: [
    namespace
  ]
}

// output testCredAdmin array = AKS.listClusterAdminCredential().kubeconfigs
// output testCredUser array = AKS.listClusterUserCredential().kubeconfigs
output hostname string= 'https://${AKSApp.serviceName}.${AKSApp.customDomain}'
