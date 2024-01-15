using '../../bicep/main.bicep'

param Deployment = {
  DeploymentId: '2'
  Environment: 'D'
  appName: 'AKS'
  orgName: 'PE'
  prefix: 'AEU1'
}

param DeploymentHub ={
  appName: 'HUB'
  orgName: 'PE'
  prefix: 'ACU1'
}

param AKSApp = [
  {
    customDomain: 'aginow.net'
    image: 'mcr.microsoft.com/azuredocs/aks-helloworld:v1'
    nameSpace: 'hello-web-app-routing'
    serviceName: 'aks-helloworld'
    titleMessage: '"Web App Routing ingress" --> Deployed with Azure Bicep'
    clusterName: '01'
  }
]

param VaultName = 'VLT01'

/* tested this and it works 
param Global = {
  global: loadJsonContent('../../archive/Global-Config.json')
  regional: loadJsonContent('../../archive/Global-AEU1.json')
}
*/
