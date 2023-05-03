<# 
setx.exe 'BICEP_TRACE' '1'
setx.exe 'BICEP_TRACING_VERBOSITY' 'Full'
Write-Output 'requires restart'
#>

param (
    [switch]$whatif
)

$Base = $PSScriptRoot
$splat = @{
    Name                  = 'Namespace_Bicep'
    ResourceGroupName     = 'AEU1-PE-AKS-RG-D2'
    TemplateFile          = "$Base\bicep\main.bicep"
    TemplateParameterFile = "$Base\tenants\AKS\values-d2.bicepparam"
}

# no longer required with az.resources 6.6.1 part of AZ 9.7.0
# test out bicep params, manually build
# bicep build-params "$Base\tenants\AKS\values-d2.bicepparam"

New-AzResourceGroupDeployment @splat -Verbose @PSBoundParameters

# az deployment group create -g $splat.ResourceGroupName -n $splat.Name --template-file $splat.TemplateFile --verbose