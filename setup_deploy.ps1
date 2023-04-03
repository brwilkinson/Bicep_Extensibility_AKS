<# 
setx.exe 'BICEP_TRACE' '1'
setx.exe 'BICEP_TRACE_LEVEL' 'Verbose'
Write-Output 'requires restart'
#>

$ParamsBase = 'D:\repos\Namespace_Bicep\tenants\LAB\values-d1'
$splat = @{
    Name                  = 'Namespace_Bicep'
    ResourceGroupName     = 'AEU1-PE-CTL-RG-D1'
    TemplateFile          = 'D:\repos\Namespace_Bicep\bicep\main.bicep'
    # bicepparam compilation not supported as yet
    TemplateParameterFile = "${ParamsBase}.json"
}

# test out biep params, manually build
bicep build-params "${ParamsBase}.bicepparam"
New-AzResourceGroupDeployment @splat -Verbose

# az deployment group create -g $splat.ResourceGroupName -n $splat.Name --template-file $splat.TemplateFile --verbose