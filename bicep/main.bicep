@description('kubernetes namespace for app')
param nameSpace string
@description('app Name used to describe the service')
param serviceName string
@description('base image to use')
param image string
@description('your external custom DNS, zone registered in Azure DNS')
param customDomain string

@description('region prefix e.g. acu1 or aeu1')
param prefix string
@description('your org name e.g. PE or HR or INF 2 or 3 letter org name')
param orgName string
@description('your org name e.g. TST or ADF or CTL 2 or 3 letter org name')
param appName string
@description('Environment e.g. d,t,u or p')
param Environment string
@description('Id for enviroment e.g. 1,2,3,4,5,6,7,8')
param DeploymentId string
@description('short name for the cluster e.g. 01 or 02 or AKS01 or AKS02')
param ClusterName string

@description('used with the azuredocs/aks-helloworld:v1 to display custom message')
param titleMessage string

var Deployment = '${prefix}-${orgName}-${appName}-${Environment}${DeploymentId}'
var hubDeployment = '${prefix}-${orgName}-${appName}-P0'
var hubRG = '${prefix}-${orgName}-${appName}-RG-P0'

resource AKS 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' existing = {
  name: '${Deployment}-aks${ClusterName}'
}

resource KV 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: '${hubDeployment}-kvVLT01'
  scope: resourceGroup(hubRG)

  resource mySecret 'secrets' existing = {
    name: serviceName
  }
}

module namespace 'namespace.bicep' = {
  name: '${serviceName}-namespace'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    nameSpace: nameSpace
  }
}

module deployment 'deployment.bicep' = {
  name: '${serviceName}-deployment'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    nameSpace: nameSpace
    name: serviceName
    image: image
    titleMessage: titleMessage
  }
  dependsOn: [
    namespace
  ]
}

module service 'service.bicep' = {
  name: '${serviceName}-service'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    nameSpace: nameSpace
    servicename: serviceName
  }
  dependsOn: [
    namespace
  ]
}

module ingress 'ingress.bicep' = {
  name: '${serviceName}-ingress'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    nameSpace: nameSpace
    hostname: '${serviceName}.${customDomain}'
    KeyVaultCertificateUri: KV::mySecret.properties.secretUri
    name: serviceName
    secretName: serviceName
  }
  dependsOn: [
    namespace
  ]
}

// output testCredAdmin array = AKS.listClusterAdminCredential().kubeconfigs
// output testCredUser array = AKS.listClusterUserCredential().kubeconfigs
