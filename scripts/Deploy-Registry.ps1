[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $WorkloadName,

    [Parameter(Mandatory = $true)]
    [ValidateSet('shared', 'dev', 'prod')]
    [string]
    $Environment
)

$resourceGroupName = "rg-$( $WorkloadName )-$( $Environment )"

$deploymentParameters = @{
    Name                  = ('deployment' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm'))
    ResourceGroupName     = $resourceGroupName
    TemplateFile          = './templates/containerRegistry.json'
    TemplateParameterFile = './templates/containerRegistry.parameters.json'
    Mode                  = 'Incremental'
}

New-AzResourceGroupDeployment @deploymentParameters -registryName "acr$( $WorkloadName )$( $environment )"
