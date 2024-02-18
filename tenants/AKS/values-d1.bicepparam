<<<<<<< HEAD:tenants/AKS/values-d1.bicepparam
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
=======
using '../../bicep/main.bicep'

param DeploymentDef = {
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

param AKSAppDefs = [
  {
    customDomain: 'aginow.net'
    image: 'mcr.microsoft.com/azuredocs/aks-helloworld:v1'
    nameSpace: 'hello-web-app-routing'
    serviceName: 'aks-helloworld'
    titleMessage: '"Web App Routing ingress" --> Deployed with Azure Bicep'
    clusterName: '01'
    tlsCertName: 'agic01-psthing-com'
  }
]

param VaultName = 'VLT01'

/* tested this and it works 
param Global = {
  global: loadJsonContent('../../archive/Global-Config.json')
  regional: loadJsonContent('../../archive/Global-AEU1.json')
}
*/
>>>>>>> 267f3b63e49833f101389b5016284d5741a50c05:tenants/AKS/values-d2.bicepparam
