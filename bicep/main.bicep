param prefix string = 'AEU1'
param orgName string = 'PE'
param appName string = 'CTL'
param Environment string = 'D'
param DeploymentId string = '1'
param ClusterName string = '01'
param nameSpace string = 'hello-web-app-routing'
param serviceName string = 'aks-helloworld'
param customDomain string = 'psthing.com'
param titleMessage string = '''
"Web App Routing ingress" --> Deployed with Azure Bicep
'''

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
  name: 'helloworldapp-namespace'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    nameSpace: nameSpace
  }
}

module deployment 'deployment.bicep' = {
  name: 'helloworldapp-deployment'
  params: {
    kubeConfig: AKS.listClusterAdminCredential().kubeconfigs[0].value
    nameSpace: nameSpace
    name: serviceName
    image: 'mcr.microsoft.com/azuredocs/aks-helloworld:v1'
    titleMessage: titleMessage
  }
  dependsOn: [
    namespace
  ]
}

module service 'service.bicep' = {
  name: 'helloworldapp-service'
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
  name: 'helloworldapp-ingress'
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
