
## Activate System Assigned Managed Identity

⌨️ Bash:

```bash
resourceGroupId=$(az group list \
        --tag owner="$(az account show --query 'user.name' -o tsv)" \
        --query '[].id' \
        -o tsv)

resourceGroupName=$(echo $resourceGroupId | sed 's|.*/||g')

automationAccountId=$(az automation account list \
    --query "[?resourceGroup=='$resourceGroupName'].id" \
    --output tsv  \
    --only-show-errors)

az rest --method patch \
    --uri "https://management.azure.com${automationAccountId}?api-version=2020-01-13-preview" \
    --body '{"identity": { "type": "SystemAssigned" }}'

automationAccountPrincipal=$(az resource show \
    --id $automationAccountId  \
    --query 'identity.principalId' \
    --out tsv)
```

⌨️ PowerShell:

```powershell
$resourceGroupId = az group list `
        --tag owner="$(az account show --query 'user.name' -o tsv)" `
        --query '[].id' `
        -o tsv

$resourceGroupName = $resourceGroupId -split '/' | Select-Object -Last 1

$automationAccountId = az automation account list `
    --query "[?resourceGroup=='$resourceGroupName'].id" `
    --output tsv  `
    --only-show-errors

az rest --method patch `
    --uri "https://management.azure.com${automationAccountId}?api-version=2020-01-13-preview" `
    --body '{"identity": { "type": "SystemAssigned" }}'

$automationAccountPrincipal = az resource show `
    --id $automationAccountId  `
    --query 'identity.principalId' `
    --out tsv
```

## Give the Reader role to the automation account on it's resource group

⌨️ Bash:

```bash
az role assignment create \
    --assignee-object-id $automationAccountPrincipal \
    --assignee-principal-type ServicePrincipal \
    --role Reader \
    --scope $resourceGroupId
```

⌨️ PowerShell:

```powershell
az role assignment create `
    --assignee-object-id $automationAccountPrincipal `
    --assignee-principal-type ServicePrincipal `
    --role Reader `
    --scope $resourceGroupId
```

## Create a runbook that returns the Automation Account Resource Id

⌨️ Bash:

```bash
runbookName='lab2'
automationAccountName=$(az automation account list \
    -g $resourceGroupName \
    --only-show-errors \
    --query '[].name' \
    -o tsv)

location=$(az group show -n $resourceGroupName --query 'location' -o tsv)

 az automation runbook create \
    --automation-account-name $automationAccountName \
    --resource-group $resourceGroupName \
    --name $runbookName \
    --type "PowerShell" \
    --only-show-errors \
    --location $location

az automation runbook replace-content \
    --automation-account-name $automationAccountName \
    --resource-group $resourceGroupName \
    --name $runbookName \
    --only-show-errors \
    --content 'Write-Output "Hello World"'

az automation runbook publish \
    --automation-account-name $automationAccountName \
    --resource-group $resourceGroupName \
    --name $runbookName \
    --only-show-errors
```

⌨️ PowerShell:

```powershell
$runbookName = 'lab2'
$automationAccountName = az automation account list `
    -g $resourceGroupName `
    --only-show-errors `
    --query '[].name' `
    -o tsv

$location = az group show -n $resourceGroupName --query 'location' -o tsv

 az automation runbook create `
    --automation-account-name $automationAccountName `
    --resource-group $resourceGroupName `
    --name $runbookName `
    --type "PowerShell" `
    --only-show-errors `
    --location $location

az automation runbook replace-content `
    --automation-account-name $automationAccountName `
    --resource-group $resourceGroupName `
    --name $runbookName `
    --only-show-errors `
    --content '@solution/lab2.ps1'

az automation runbook publish `
    --automation-account-name $automationAccountName `
    --resource-group $resourceGroupName `
    --name $runbookName `
    --only-show-errors
```

