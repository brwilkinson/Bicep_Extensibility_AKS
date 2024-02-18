<# 
setx.exe 'BICEP_TRACING_ENABLED' 'True'
setx.exe 'BICEP_TRACING_VERBOSITY' 'Full'
Write-Output 'requires restart'
#>

param (
    [switch]$whatif,

    $ResourceGroupName = 'ACU1-PE-AKS-RG-D1',

    $ResourceGroupLocation = 'EastUS2'
)

$Base = $PSScriptRoot
$splat = @{
    Name                  = 'Namespace_Bicep'
    ResourceGroupName     = $ResourceGroupName
    TemplateFile          = "$Base\bicep\main.bicep"
    TemplateParameterFile = "$Base\tenants\AKS\values-d1.bicepparam"
}

# no longer required with az.resources 6.6.1 part of AZ 9.7.0
# test out bicep params, manually build
# bicep build-params "$Base\tenants\AKS\values-d2.bicepparam"

New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose
New-AzResourceGroupDeployment @splat -Verbose @PSBoundParameters

# az deployment group create -g $splat.ResourceGroupName -n $splat.Name --template-file $splat.TemplateFile --verbose