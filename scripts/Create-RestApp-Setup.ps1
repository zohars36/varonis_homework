param (
        [Parameter()][string]$ResourceGroupName = "CommonInfra",

        [Parameter()][string]$StorageAccountName = "commoninfravarsa",
        
        [Parameter()][string]$ContainerName = "tfstates",

        [Parameter()][string]$Location = "West Europe"
    )


# Sign in to Azure (You may need to login if not authenticated)
#Connect-AzAccount
#az login

# Create a new resource group
if (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue){
    Write-Host "resource group already exist !"
    exit 0
}

New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Create a storage account
az storage account create -n $StorageAccountName -g $ResourceGroupName -l $Location --sku Standard_LRS
#New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageAccountName -Location $location -SkuName Standard_LRS -Kind StorageV2

# Get storage account context
$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
$storageContext = $storageAccount.Context

# Create a blob container
New-AzStorageContainer -Name $ContainerName -Context $storageContext

