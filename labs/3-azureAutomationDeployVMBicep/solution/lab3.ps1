# Ensures you do not inherit an AzContext in your runbook
$null = Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# Assumes that there is only one storage account visible to this Managed Identity
$storageAccount = Get-AzStorageAccount
$resourceGroupName = $storageAccount.ResourceGroupName
$containerName = 'template'

$blob = Get-AzStorageBlob `
    -Container $containerName `
    -Context $storageAccount.Context `
    -Blob 'vm/azuredeploy.json' `
    -WarningAction SilentlyContinue

$templateUri = New-AzStorageBlobSASToken `
    -Blob $blob.Name `
    -Container $containerName `
    -Context $storageAccount.Context `
    -ExpiryTime (Get-Date).AddMinutes(10) `
    -Permission 'r' `
    -FullUri

New-AzResourceGroupDeployment `
    -TemplateUri $templateUri `
    -ResourceGroupName $resourceGroupName `
    -adminPasswordOrKey ('Pa$$w0rdPa$$w0rd' | ConvertTo-SecureString -AsPlainText -Force)