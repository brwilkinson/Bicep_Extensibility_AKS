

@export()
type DeploymentHubT = {
  @description('The object to define the Hub Deployment')
  prefix: string
  orgName: string
  appName: string
}

@export()
type DeploymentT = {
  @description('The object to define the Deployment')
  prefix: string
  orgName: string
  appName: string
  Environment: string
  DeploymentId: string
}

@export()
func DeploymentName(Deployment DeploymentT) string => 
  '${Deployment.prefix}-${Deployment.orgName}-${Deployment.appName}-${Deployment.Environment}${Deployment.DeploymentId}'

@export()
func DeploymentHubName(DeploymentHub DeploymentHubT) string => 
'${DeploymentHub.prefix}-${DeploymentHub.orgName}-${DeploymentHub.appName}-P0'

@export()
func DeploymentHubRGName(DeploymentHub DeploymentHubT) string => 
'${DeploymentHub.prefix}-${DeploymentHub.orgName}-${DeploymentHub.appName}-RG-P0'
