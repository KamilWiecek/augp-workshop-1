[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $WorkloadName,

    [Parameter(Mandatory = $true)]
    [ValidateSet('dev','prod')]
    [string]
    $Environment,

    [Parameter()]
    [string]
    $Tag
)

$resourceGroupName = "rg-$( $WorkloadName )-$( $Environment )"
$repositoryAndTag = "$($WorkloadName):$($Tag)"
$containerRegistryResourceId = "/subscriptions/$( (Get-AzContext).Subscription.Id )/resourceGroups/rg-$( $WorkloadName )-shared/providers/Microsoft.ContainerRegistry/registries/acr$( $WorkloadName )shared" 

$deploymentParameters = @{
    Name                        = ('deployment' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm-ss'))
    ResourceGroupName           = $resourceGroupName 
    TemplateFile                = './templates/containerInstance.json'
    TemplateParameterFile       = './templates/containerInstance.parameters.json'
    Mode                        = 'Incremental'

    environment                 = $Environment
    workloadName                = $WorkloadName
    containerRegistryResourceId = $containerRegistryResourceId
    repositoryNameAndTag        = $repositoryAndTag
}

New-AzResourceGroupDeployment @deploymentParameters
