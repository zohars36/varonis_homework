
<#
  .SYNOPSIS
  rest app pipelines setup

  .DESCRIPTION
  on the azure project:
  1. create varibale group for ADO pipelines.
  2. create pipelines.
  
  .EXAMPLE
  PS> ./Create-RestApp-Pipelines.ps1 -Org "sizcloud" -Project "varonis2" -ServiceName "Varonis2AzureConnection" -Repository "https://github.com/zohars36/varonis_homework"

#>
param (
        [Parameter()][string]$ResourceGroupName = "CommonInfra",

        [Parameter()][string]$StorageAccountName = "commoninfravarsa",
        
        [Parameter()][string]$ContainerName = "tfstates",

        [Parameter(Mandatory=$true)][string]$Org = "sizcloud",

        [Parameter(Mandatory=$true)][string]$Project = "varonis",
        
        [Parameter(Mandatory=$true)][string]$ServiceName = "SizCloudTestConnection",

        [Parameter(Mandatory=$true)][string]$Repository = "https://github.com/zohars36/varonis_homework"
    )

$groupName="rest-app-infra-group"
$fileName="common.infra.terraform.tfstate"
$dev_org="https://dev.azure.com/" + $Org + "/"


# create variable group for rest app pipelines
$var1 = "backendAzureRmContainerName=" + $ContainerName 
$var2 = "backendAzureRmKey=" + $FileName 
$var3 = "backendAzureRmResourceGroupName=" + $ResourceGroupName 
$var4 = "backendAzureRmStorageAccountName=" + $StorageAccountName
$var5 = "defaultServiceName=" + $ServiceName

az pipelines variable-group create `
    --name $groupName `
    --variables $var1 $var2 $var3 $var4 $var5 `
    --authorize true `
    --description "rest app group" `
    --org $dev_org `
    --project $Project

# create azure-pipelines-deploy.yml 
az pipelines create --name 'Rest Web App - Deploy' `
--repository $Repository `
--branch main `
--org $dev_org `
--project $Project `
--yml-path pipelines/azure-pipelines-deploy.yml `
--skip-first-run

# create azure-pipelines-restappinfra-apply.yml
az pipelines create --name 'Rest App Infra - Apply' `
--repository $Repository `
--branch main `
--org $dev_org `
--project $Project `
--yml-path pipelines/azure-pipelines-restappinfra-apply.yml `
--skip-first-run

# create azure-pipelines-deploy.yml
az pipelines create --name 'Rest App Infra - Destroy' `
--repository $Repository `
--branch main `
--org $dev_org `
--project $Project `
--yml-path pipelines/azure-pipelines-restappinfra-destroy.yml `
--skip-first-run 

# create azure-pipelines-restwebapp-apply.yml
az pipelines create --name 'Rest Web App - Apply' `
--repository $Repository `
--branch main `
--org $dev_org `
--project $Project `
--yml-path pipelines/azure-pipelines-restwebapp-apply.yml `
--skip-first-run

# create aazure-pipelines-restwebapp-destroy
az pipelines create --name 'Rest Web App - Destroy' `
--repository $Repository `
--branch main `
--org $dev_org `
--project $Project `
--yml-path pipelines/azure-pipelines-restwebapp-destroy.yml `
--skip-first-run
