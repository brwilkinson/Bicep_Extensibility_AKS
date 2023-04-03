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
