<# 
setx.exe 'BICEP_TRACE' '1'
setx.exe 'BICEP_TRACE_LEVEL' 'Verbose'
Write-Output 'requires restart'
#>

$Base = $PSScriptRoot
$ParamsBase = "$Base\tenants\LAB\values-d1"
$splat = @{
    Name                  = 'Namespace_Bicep'
    ResourceGroupName     = 'AEU1-PE-CTL-RG-D1'
    TemplateFile          = "$Base\bicep\main.bicep"
    TemplateParameterFile = "${ParamsBase}.json" # bicepparam compilation not supported as yet
}

# test out biep params, manually build
bicep build-params "${ParamsBase}.bicepparam"
New-AzResourceGroupDeployment @splat -Verbose

# az deployment group create -g $splat.ResourceGroupName -n $splat.Name --template-file $splat.TemplateFile --verbose